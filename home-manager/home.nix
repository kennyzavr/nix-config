{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.stylix.homeModules.stylix
    inputs.nixvim.homeManagerModules.nixvim
    inputs.niri.homeModules.stylix
    inputs.niri.homeModules.niri
    inputs.self.homeManagerModules.devtools
    inputs.self.homeManagerModules.nixvim
    inputs.self.homeManagerModules.desktop-shell
    inputs.self.homeManagerModules.desktop-shell-nvidia
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

  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
    polarity = "dark";
  };

  stylix.targets = {
    qt.enable = true;
    gtk.enable = true;
    gnome.enable = true;
    kde.enable = true;
  };

  stylix.fonts = {
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

  desktop-shell = {
    enable = true;
    terminalBin = "${pkgs.alacritty}/bin/alacritty";
  };

  home.stateVersion = "25.05";
}
