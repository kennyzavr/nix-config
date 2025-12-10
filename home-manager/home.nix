{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.self.homeManagerModules.devtools
    inputs.self.homeManagerModules.nixvim
    inputs.self.homeManagerModules.shell
    inputs.self.homeManagerModules.tty
    inputs.self.homeManagerModules.proxy
    inputs.self.homeManagerModules.librewolf
  ];

  nixpkgs = {
    # You can add overlays here
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
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  home = {
    username = "kennyzar";
    homeDirectory = "/home/kennyzar";
  };

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    inter
    dejavu_fonts
    noto-fonts-emoji
    base16-schemes
    qemu
    spotify
    telegram-desktop
    nix-index
    obs-studio
  ];

  fonts.fontconfig.enable = true;

  # disabledModules = [
  #     "${inputs.stylix}/modules/anki/hm.nix"
  #     "${inputs.stylix}/modules/ashell/hm.nix"
  # ];

  stylix = {
    enable = true;

    autoEnable = false;

    targets = {
      #       bemenu = {
      # enable = true;
      # alternate = true;
      #       };
      #       swaylock.enable = true;
      #       waybar = {
      #         enable = true;
      #         addCss = false;
      #       };
      # sway.enable = true;
      # alacritty.enable = true;
      # nixvim.enable = true;
      # librewolf = {
      #   enable = true;
      #   profileNames = [ "default" ];
      #   colorTheme.enable = true;
      # };
    };

    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };

    opacity = {
      applications = 1.0;
      terminal = 1.0;
    };
  };

  my.shell = {
    enable = true;
    terminalBin = "${pkgs.alacritty}/bin/alacritty";
    menuBin = "${pkgs.bemenu}/bin/bemenu-run";
    idleTimeout = 180;
  };

  home.stateVersion = "25.05";
}
