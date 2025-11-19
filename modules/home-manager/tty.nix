{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # alacritty-theme
    # nerd-fonts.jetbrains-mono
  ];

  programs.bash = {
    enable = true;
    # bashrcExtra = ''
    #   if [ -r "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
    #     . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    #   fi
    # '';
  };

  stylix.targets = {
    alacritty.enable = true;
  };

  programs.tmux = {
    enable = true;
    prefix = "C-a";
    shortcut = "a";
    terminal = "tmux-256color";
    baseIndex = 1;
    keyMode = "vi";
    extraConfig = ''
      unbind C-b

      set -as terminal-features ",*:RGB"

      setw -g pane-base-index 1
      set -g renumber-windows on
    '';
  };

  programs.alacritty = {
    enable = true;
    #themePackage = pkgs.alacritty-theme;
    #theme = "Gruvbox Material Medium Light";
    # settings = {
    # general = {
    #   import = [
    #     "${pkgs.alacritty-theme}/share/alacritty-theme/gruvbox_material_medium_light.toml"
    #   ];
    # };
    #   window = {
    #     decorations = "None";
    #     decorations_theme_variant = "Light";
    #   };
    #
    #   font = {
    #     normal = {
    #       family = "JetBrainsMono Nerd Font";
    #       style  = "Regular";
    #     };
    #     size = 12.0;
    #   };
    # };
  };

  # programs.zsh = {
  #   enable = true;
  #   enableCompletion = true;
  #   autosuggestion.enable = true;
  #   syntaxHighlighting.enable = true;
  #
  #   dotDir = ".config/zsh";
  #
  #   shellAliases = {
  #     # hms = "home-manager switch";
  #     # lg = "lazygit";
  #     # v = "nvim";
  #     # c = "clear";
  #     # cat = "bat --theme='Catppuccin Mocha'";
  #     # fk = "fuck";
  #     # ls = "eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions";
  #     # cd = "z";
  #     # s = "web_search duckduckgo";
  #   };
  #   oh-my-zsh = {
  #     enable = true;
  #     # extraConfig = builtins.readFile ./extraConfig.zsh;
  #     # Additional oh-my-zsh plugins
  #     plugins = [
  #       "web-search"
  #       "copyfile"
  #       "copybuffer"
  #       "fzf"
  #     ];
  #   };
  #
  #   plugins = [
  #     # Autocompletions
  #     {
  #       name = "zsh-autosuggestions";
  #       src = pkgs.fetchFromGitHub {
  #         owner = "zsh-users";
  #         repo = "zsh-autosuggestions";
  #         rev = "v0.7.1";
  #         hash = "sha256-vpTyYq9ZgfgdDsWzjxVAE7FZH4MALMNZIFyEOBLm5Qo=";
  #       };
  #     }
  #     # Completion scroll
  #     {
  #       name = "zsh-completions";
  #       src = pkgs.fetchFromGitHub {
  #         owner = "zsh-users";
  #         repo = "zsh-completions";
  #         rev = "0.35.0";
  #         hash = "sha256-GFHlZjIHUWwyeVoCpszgn4AmLPSSE8UVNfRmisnhkpg=";
  #       };
  #     }
  #     # Highlight commands in terminal
  #     {
  #       name = "zsh-syntax-highlighting";
  #       src = pkgs.fetchFromGitHub {
  #         owner = "zsh-users";
  #         repo = "zsh-syntax-highlighting";
  #         rev = "0.8.0";
  #         hash = "sha256-iJdWopZwHpSyYl5/FQXEW7gl/SrKaYDEtTH9cGP7iPo=";
  #       };
  #     }
  #   ];
  #   initExtra = ''
  #     if
  #     ;
  #             [[ ! -f ~/.config/home-manager/.p10k.zsh ]] || source ~/.config/home-manager/.p10k.zsh
  #   '';
  # };
  #
  # home.sessionVariables = {
  #   TERMINAL = "alacritty";
  # };
}
