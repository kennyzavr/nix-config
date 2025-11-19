{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.nixvim = {
    keymaps = [
      {
        key = "<leader>f";
        action = "<cmd>format<CR>";
        mode = "n";
        # desc = "LSP format buffer";
      }
    ];

    plugins = {
      lsp = {
        enable = true;

        inlayHints = true;

        keymaps = {
          # preset = "default";

          lspBuf = {
            gd = "definition";
            gD = "references";
            gt = "type_definition";
            gi = "implementation";
            K = "hover";
            re = "rename";
          };

          diagnostic = {
            "[d" = "goto_prev";
            "]d" = "goto_next";
            "gl" = "open_float";
          };
        };

        servers = {
          lua_ls.enable = true;
          nixd.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
          clangd.enable = true;
        };
      };

      lsp-format = {
        enable = true;
      };
    };
  };
}
