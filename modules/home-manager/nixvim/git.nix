{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.nixvim = {
    plugins = {
      # Индикаторы изменений по строкам
      gitsigns = {
        enable = true;

        settings = {
          signs = {
            add = {text = "+";};
            change = {text = "~";};
            delete = {text = "_";};
            topdelete = {text = "‾";};
            changedelete = {text = "~";};
          };

          signcolumn = true;
          numhl = false;
          linehl = false;

          current_line_blame = true;
          current_line_blame_opts = {
            delay = 500;
          };

          # простые бинды через on_attach
          on_attach = ''
            function(bufnr)
              local gs = package.loaded.gitsigns

              local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
              end

              -- навигация по хункам
              map("n", "]c", function()
                if vim.wo.diff then return "]c" end
                vim.schedule(function() gs.next_hunk() end)
                return "<Ignore>"
              end, { expr = true })

              map("n", "[c", function()
                if vim.wo.diff then return "[c" end
                vim.schedule(function() gs.prev_hunk() end)
                return "<Ignore>"
              end, { expr = true })

              -- действия с хунками
              map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
              map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
              map("n", "<leader>hS", gs.stage_buffer)
              map("n", "<leader>hu", gs.undo_stage_hunk)
              map("n", "<leader>hR", gs.reset_buffer)

              map("n", "<leader>hp", gs.preview_hunk)
              map("n", "<leader>hb", function() gs.blame_line({ full = true }) end)
            end
          '';
        };
      };

      # Классический git-интерфейс
      fugitive = {
        enable = true;
        # основные команды:
        # :G         – статус
        # :G commit  – коммит
        # :Gdiff     – дифф текущего файла
      };

      # Удобные диффы (опционально)
      diffview = {
        enable = true;
        # полезные команды:
        # :DiffviewOpen             – дифф с HEAD
        # :DiffviewOpen HEAD~1      – дифф с конкретным коммитом/веткой
        # :DiffviewFileHistory      – история файла
      };
    };

    # глобальные keymaps для git
    keymaps = [
      # быстро открыть статус git
      {
        key = "<leader>gs";
        action = "<cmd>G<CR>";
        mode = "n";
        options = {
          desc = "Git status (fugitive)";
        };
      }

      # открыть diffview
      {
        key = "<leader>gd";
        action = "<cmd>DiffviewOpen<CR>";
        mode = "n";
        options = {
          desc = "Diffview open";
        };
      }

      {
        key = "<leader>gh";
        action = "<cmd>DiffviewFileHistory %<CR>";
        mode = "n";
        options = {
          desc = "Diffview file history (current file)";
        };
      }
    ];
  };
}
