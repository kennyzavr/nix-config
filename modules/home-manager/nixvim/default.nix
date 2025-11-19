{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./telescope.nix
    ./lsp.nix
    ./completion.nix
    ./treesitter.nix
    ./neotree.nix
    ./lualine.nix
    ./git.nix
  ];

  stylix.targets = {
    nixvim.enable = true;
  };

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    luaLoader.enable = true;

    globals.mapleader = ",";
    globals.maplocalleader = ",";

    clipboard.register = "unnamedplus";

    clipboard.providers.wl-copy.enable = true;

    opts = {
      updatetime = 100;
      relativenumber = true;
      number = true;
      mouse = "a";
      mousemodel = "extend";
      ignorecase = true;
      smartcase = true;
      cursorline = true;
      fileencoding = "utf-8";
      termguicolors = true;
      wrap = false;
      tabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      autoindent = true;
    };

    highlight.Todo = {
      fg = "Blue";
      bg = "Yellow";
    };

    match.TODO = "TODO";

    plugins = {
      web-devicons.enable = true;

      nvim-autopairs.enable = true;

      nvim-surround.enable = true;

      indent-o-matic.enable = true;

      comment.enable = true;

      which-key.enable = true;
    };
  };
}
