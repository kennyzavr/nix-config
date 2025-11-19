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
    keymaps = [
      {
        key = "<leader>e";
        action = "<cmd>Neotree toggle<CR>";
        options = {
          desc = "Toggle file tree";
        };
      }

      {
        key = "<leader>fe";
        action = "<cmd>Neotree reveal<CR>";
        options = {
          desc = "Reveal current file in tree";
        };
      }
    ];
    plugins = {
      neo-tree = {
        enable = true;

        closeIfLastWindow = true;

        popupBorderStyle = "rounded";

        enableGitStatus = true;
        enableDiagnostics = true;

        filesystem = {
          followCurrentFile.enabled = true;
          filteredItems = {
            hideDotfiles = false;
            hideGitignored = false;
          };

          hijackNetrwBehavior = "open_default";
        };

        defaultComponentConfigs = {
          indent = {
            withMarkers = true;
            indentSize = 2;
          };

          icon = {
            folderClosed = "";
            folderOpen = "";
            folderEmpty = "󰜌";
          };

          gitStatus = {
            symbols = {
              added = "✚";
              modified = "";
              deleted = "✖";
              renamed = "";
              untracked = "";
              ignored = "";
              unstaged = "";
              staged = "";
              conflict = "";
            };
          };
        };

        window = {
          position = "left";
          width = 30;
        };

        eventHandlers = {
          "neo_tree_buffer_enter" = ''
            function()
              vim.opt_local.number = true
              vim.opt_local.relativenumber = true
            end
          '';
        };
      };
    };
  };
}
