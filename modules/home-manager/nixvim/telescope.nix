{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.ripgrep
  ];

  programs.nixvim = {
    plugins = {
      telescope = {
        enable = true;

        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>fb" = "buffers";
          "<leader>fh" = "help_tags";

          "<leader>fw" = "grep_string";
          "<leader>fr" = "oldfiles";
          "<leader>fR" = "registers";

          "<leader>fd" = "diagnostics";
          "<leader>ld" = "lsp_definitions";
          "<leader>lr" = "lsp_references";
          "<leader>li" = "lsp_implementations";
          "<leader>ls" = "lsp_document_symbols";
        };

        settings = {
          defaults = {
            layout_strategy = "flex";
            layout_config = {
              horizontal = {
                preview_width = 0.55;
              };
              vertical = {
                preview_height = 0.4;
              };
              width = 0.9;
              height = 0.9;
            };

            file_ignore_patterns = [
              ".git/"
              "node_modules/"
              "target/"
              "dist/"
              "build/"
            ];

            mappings = {
              i = {
                "<Esc>" = "close";
                "<C-j>" = "move_selection_next";
                "<C-k>" = "move_selection_previous";
              };
              n = {
                "<C-c>" = "close";
              };
            };
          };
        };

        extensions = {
          fzf-native = {
            enable = true;
          };
          ui-select.enable = true;
        };
      };
    };
  };
}
