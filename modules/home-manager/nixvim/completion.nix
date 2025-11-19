{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.nixvim = {
    plugins = {
      luasnip.enable = true;

      friendly-snippets.enable = true;

      blink-cmp = {
        enable = true;

        settings = {
          snippets = {
            preset = "luasnip";
          };

          appearance = {
            use_nvim_cmp_as_default = false;
            nerd_font_variant = "mono";
          };

          completion = {
            accept = {
              auto_brackets = {
                enabled = true;
              };
            };

            list = {
              selection = {
                preselect = false;
                auto_insert = true;
              };
            };

            documentation = {
              auto_show = true;
              auto_show_delay_ms = 200;
            };

            ghost_text = {
              enabled = true;
            };
          };

          sources = {
            default = [
              "lsp"
              "path"
              "snippets"
              "buffer"
            ];

            providers = {
              lsp = {score_offset = 0;};
              path = {score_offset = 3;};
              snippets = {score_offset = 2;};
              buffer = {score_offset = -1;};
            };
          };

          keymap = {
            preset = "default";
            "<Tab>" = ["snippet_forward" "fallback"];
            "<S-Tab>" = ["snippet_backward" "fallback"];
            "<C-Space>" = ["show" "show_documentation" "hide_documentation"];
            "<C-e>" = ["hide"];
          };
        };
      };
    };
  };
}
