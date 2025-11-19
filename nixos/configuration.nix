{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    #inputs.self.nixosModules.librewolf
    inputs.self.nixosModules.pipewire
    inputs.self.nixosModules.shell
  ];

  # fileSystems."/" = {
  #     device = "/dev/disk/by-label/root";
  #     fsType = "ext4";
  # };
  #
  # swapDevices = [
  #     { device = "/dev/disk/by-label/swap"; }
  # ];

  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      inputs.self.overlays.additions
      inputs.self.overlays.modifications
      inputs.self.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "kennyzar-lt";
  networking.networkmanager.enable = true;

  security.pam.services.swaylock = {};

  time.timeZone = "Asia/Novosibirsk";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    useXkbConfig = false; # use xkb.options in tty.
  };

  # fonts = {
  #     fontDir.enable = true;
  #     fontconfig = {
  #         enable = true;
  #         antialias = true;
  #         hinting.enable = true;
  #         hinting.style = "full";
  #         subpixel.rgba = "rgb";
  #     };
  # };

  users = {
    groups = {
      kennyzar = {};
    };
    users = {
      kennyzar = {
        isNormalUser = true;
        group = "kennyzar";
        extraGroups = [
          "wheel"
          "networkmanager"
          "audio"
          "video"
          "input"
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    neovim-unwrapped
  ];

  system.stateVersion = "25.05";
}
