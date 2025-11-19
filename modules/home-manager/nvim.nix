{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
# let
#     pallete = config.stylix.base16;
# in
{
  home.packages = with pkgs; [
    llvmPackages_21.clang
    #gcc
    gnumake
    stylua
    lua54Packages.lua
    lua-language-server
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    extraLuaConfig = ''
      vim.g.mapleader = ','
      vim.g.maplocalleader = ','

      vim.g.have_nerd_font = true

      vim.o.number = true
      vim.o.relativenumber = true

      vim.o.mouse = 'a'

      vim.o.showmode = false

      vim.schedule(function()
        vim.o.clipboard = 'unnamedplus'
      end)

      vim.o.breakindent = true

      vim.opt.expandtab = true
      vim.opt.shiftwidth = 4
      vim.opt.tabstop = 4
      vim.opt.softtabstop = 4

      vim.o.undofile = true

      vim.o.ignorecase = true
      vim.o.smartcase = true

      vim.o.signcolumn = 'yes'

      vim.o.updatetime = 250

      vim.o.timeoutlen = 300

      vim.o.splitright = true
      vim.o.splitbelow = true

      vim.o.list = true
      vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

      vim.opt.termguicolors = true

      vim.o.background = 'light'

      vim.opt.laststatus = 3

      vim.o.inccommand = 'split'

      vim.o.cursorline = true

      vim.o.scrolloff = 10

      vim.o.confirm = true

      vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

      vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

      vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

      -- TIP: Disable arrow keys in normal mode
      -- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
      -- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
      -- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
      -- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

      vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
      vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
      vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
      vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

      -- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
      -- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
      -- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
      -- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

      vim.api.nvim_create_autocmd('TextYankPost', {
        desc = 'Highlight when yanking (copying) text',
        group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
        callback = function()
          vim.hl.on_yank()
        end,
      })

      vim.g.have_nerd_font = vim.g.have_nerd_font or false
      local icons = vim.g.have_nerd_font and {} or {
          cmd    = '⌘',
          config = '🛠',
          event  = '📅',
          ft     = '📂',
          init   = '⚙',
          keys   = '🗝',
          plugin = '🔌',
          runtime= '💻',
          require= '🌙',
          source = '📄',
          start  = '🚀',
          task   = '📌',
          lazy   = '💤 ',
      }
      vim.g.ui_icons = icons

      require("nvim-treesitter.configs").setup({
          -- ensure_installed = {
          --   "bash",
          --   "c",
          --   "nix",
          --   "diff",
          --   "html",
          --   "lua",
          --   "luadoc",
          --   "markdown",
          --   "markdown_inline",
          --   "query",
          --   "vim",
          --   "vimdoc",
          -- },
          auto_install = false,
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = { "ruby" },
          },
          indent = {
            enable = true,
            disable = { "ruby" },
          },
      })
    '';
    plugins = [
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
        p.tree-sitter-c
        p.tree-sitter-cpp
        p.tree-sitter-rust
        p.tree-sitter-lua
        p.tree-sitter-bash
        p.tree-sitter-nix
        p.tree-sitter-diff
        p.tree-sitter-html
        p.tree-sitter-luadoc
        p.tree-sitter-markdown
        p.tree-sitter-markdown_inline
        p.tree-sitter-query
        p.tree-sitter-vim
        p.tree-sitter-vimdoc
      ]))
      # {
      #     plugin = pkgs.vimPlugins.gruvbox-material;
      #     type = "lua";
      #     config = ''
      #         -- Core look
      #         -- vim.o.termguicolors = true
      #         -- vim.o.background = "light"  -- "dark" or "light"
      #         vim.g.gruvbox_material_background = 'medium' -- "hard" | "medium" | "soft"
      #         vim.g.gruvbox_material_foreground = 'material' -- "mix" | "original" | "material"
      #
      #         -- Style toggles
      #         vim.g.gruvbox_material_enable_italic = 1
      #         vim.g.gruvbox_material_disable_italic_comment = 0
      #         vim.g.gruvbox_material_better_performance = 1
      #         -- Set 1 for transparent (nice if your terminal has its own background)
      #         vim.g.gruvbox_material_transparent_background = 0
      #
      #         -- Diagnostics & UI
      #         vim.g.gruvbox_material_diagnostic_text_highlight = 1
      #         vim.g.gruvbox_material_diagnostic_virtual_text = 'colored' -- or "grey"
      #         vim.g.gruvbox_material_ui_contrast = 'high' -- or "low"
      #         vim.g.gruvbox_material_sign_column_background = 'none' -- "default" | "none"
      #
      #         vim.cmd.colorscheme 'gruvbox-material'
      #     '';
      # }
      {
        plugin = pkgs.vimPlugins.lualine-nvim;
        type = "lua";
        config = ''
          require("lualine").setup({
              options = {
                  theme = 'gruvbox-material',
                  icons_enabled = true,
                  globalstatus = true,
                  component_separators = { left = '│', right = '│' },
                  section_separators = { left = '', right = '' },
                  disabled_filetypes = { 'alpha', 'dashboard', 'neo-tree' },
              },
              sections = {
                  lualine_a = { {
                    'mode',
                    fmt = function(s)
                      return s:sub(1, 1)
                    end,
                  } },
                  lualine_b = { 'branch', 'diff', { 'diagnostics', sources = { 'nvim_lsp' } } },
                  lualine_c = { { 'filename', path = 1 } }, -- относительный путь
                  lualine_x = { 'encoding', 'fileformat', 'filetype' },
                  lualine_y = { 'progress' },
                  lualine_z = { 'location' },
              },
              inactive_sections = {
                  lualine_a = {},
                  lualine_b = {},
                  lualine_c = { 'filename' },
                  lualine_x = { 'location' },
                  lualine_y = {},
                  lualine_z = {},
              },
          })
        '';
      }
      pkgs.vimPlugins.nvim-autopairs
      pkgs.vimPlugins.indent-blankline-nvim
      {
        plugin = pkgs.vimPlugins.neo-tree-nvim;
        type = "lua";
        config = ''
          require("neo-tree").setup({
              filesystem = {
                  window = {
                      mappings = {
                          ['\\'] = 'close_window',
                      },
                  },
              },
          })
        '';
      }
      pkgs.vimPlugins.nui-nvim
      {
        plugin = pkgs.vimPlugins.guess-indent-nvim;
        type = "lua";
        config = ''
          require("guess-indent").setup({
              auto_cmd = true,
          })
        '';
      }
      {
        plugin = pkgs.vimPlugins.gitsigns-nvim;
        type = "lua";
        config = ''
          require("gitsigns").setup({
              signs = {
                  add = { text = '+' },
                  change = { text = '~' },
                  delete = { text = '_' },
                  topdelete = { text = '‾' },
                  changedelete = { text = '~' },
              },
              on_attach = function(bufnr)
                  local gitsigns = require 'gitsigns'

                  local function map(mode, l, r, opts)
                      opts = opts or {}
                      opts.buffer = bufnr
                      vim.keymap.set(mode, l, r, opts)
                  end

                  -- Navigation
                  map('n', ']c', function()
                      if vim.wo.diff then
                          vim.cmd.normal { ']c', bang = true }
                      else
                          gitsigns.nav_hunk 'next'
                      end
                  end, { desc = 'Jump to next git [c]hange' })

                  map('n', '[c', function()
                      if vim.wo.diff then
                          vim.cmd.normal { '[c', bang = true }
                      else
                          gitsigns.nav_hunk 'prev'
                      end
                  end, { desc = 'Jump to previous git [c]hange' })

                  -- Actions
                  -- visual mode
                  map('v', '<leader>hs', function()
                      gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
                  end, { desc = 'git [s]tage hunk' })
                  map('v', '<leader>hr', function()
                      gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
                  end, { desc = 'git [r]eset hunk' })
                  -- normal mode
                  map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
                  map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
                  map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
                  map('n', '<leader>hu', gitsigns.stage_hunk, { desc = 'git [u]ndo stage hunk' })
                  map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
                  map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
                  map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
                  map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
                  map('n', '<leader>hD', function()
                      gitsigns.diffthis '@'
                  end, { desc = 'git [D]iff against last commit' })
                  -- Toggles
                  map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
                  map('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })
              end,

          })
        '';
      }
      pkgs.vimPlugins.telescope-fzf-native-nvim
      pkgs.vimPlugins.telescope-ui-select-nvim
      pkgs.vimPlugins.nvim-web-devicons
      {
        plugin = pkgs.vimPlugins.telescope-nvim;
        type = "lua";
        config = ''
          require("telescope").setup({
              extensions = {
                  ['ui-select'] = {
                      require('telescope.themes').get_dropdown(),
                  },
              },
          })

          -- Enable Telescope extensions if they are installed
          pcall(require('telescope').load_extension, 'fzf')
          pcall(require('telescope').load_extension, 'ui-select')

          -- See `:help telescope.builtin`
          local builtin = require 'telescope.builtin'
          vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
          vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
          vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
          vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
          vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
          vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
          vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
          vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
          vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
          vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

          -- Slightly advanced example of overriding default behavior and theme
          vim.keymap.set('n', '<leader>/', function()
            -- You can pass additional configuration to Telescope to change the theme, layout, etc.
            builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
              winblend = 10,
              previewer = false,
            })
          end, { desc = '[/] Fuzzily search in current buffer' })

          -- It's also possible to pass additional configuration options.
          --  See `:help telescope.builtin.live_grep()` for information about particular keys
          vim.keymap.set('n', '<leader>s/', function()
            builtin.live_grep {
              grep_open_files = true,
              prompt_title = 'Live Grep in Open Files',
            }
          end, { desc = '[S]earch [/] in Open Files' })

          -- Shortcut for searching your Neovim configuration files
          vim.keymap.set('n', '<leader>sn', function()
            builtin.find_files { cwd = vim.fn.stdpath 'config' }
          end, { desc = '[S]earch [N]eovim files' })
        '';
      }
      {
        plugin = pkgs.vimPlugins.lazydev-nvim;
        # ft = lua
        type = "lua";
        config = ''
          require("lazydev").setup({
              -- library = {
              --    -- Load luvit types when the `vim.uv` word is found
              --    { path = '?/luv/library', words = { 'vim%.uv' } },
              --},
          })
        '';
      }
      {
        plugin = pkgs.vimPlugins.nvim-lspconfig;
        type = "lua";
        config = ''
          vim.api.nvim_create_autocmd('LspAttach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
              callback = function(event)
                  local map = function(keys, func, desc, mode)
                      mode = mode or 'n'
                      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                  end

                  map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
                  map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
                  map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
                  map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
                  map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
                  map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                  map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
                  map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
                  map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

                  local function client_supports_method(client, method, bufnr)
                      if vim.fn.has 'nvim-0.11' == 1 then
                        return client:supports_method(method, bufnr)
                      else
                        return client.supports_method(method, { bufnr = bufnr })
                      end
                  end

                  local client = vim.lsp.get_client_by_id(event.data.client_id)
                  if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
                      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
                      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                          buffer = event.buf,
                          group = highlight_augroup,
                          callback = vim.lsp.buf.document_highlight,
                      })

                      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                          buffer = event.buf,
                          group = highlight_augroup,
                          callback = vim.lsp.buf.clear_references,
                      })

                      vim.api.nvim_create_autocmd('LspDetach', {
                          group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                          callback = function(event2)
                              vim.lsp.buf.clear_references()
                              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                          end,
                      })
                  end

                  if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
                      map('<leader>th', function()
                          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
                      end, '[T]oggle Inlay [H]ints')
                  end
              end,
          })

          vim.diagnostic.config {
              severity_sort = true,
              float = { border = 'rounded', source = 'if_many' },
              underline = { severity = vim.diagnostic.severity.ERROR },
              signs = vim.g.have_nerd_font and {
                  text = {
                      [vim.diagnostic.severity.ERROR] = '󰅚 ',
                      [vim.diagnostic.severity.WARN] = '󰀪 ',
                      [vim.diagnostic.severity.INFO] = '󰋽 ',
                      [vim.diagnostic.severity.HINT] = '󰌶 ',
                  },
              } or {},
              virtual_text = {
                  source = 'if_many',
                  spacing = 2,
                  format = function(diagnostic)
                      local diagnostic_message = {
                          [vim.diagnostic.severity.ERROR] = diagnostic.message,
                          [vim.diagnostic.severity.WARN] = diagnostic.message,
                          [vim.diagnostic.severity.INFO] = diagnostic.message,
                          [vim.diagnostic.severity.HINT] = diagnostic.message,
                      }
                      return diagnostic_message[diagnostic.severity]
                  end,
              },
          }

          local capabilities = require('blink.cmp').get_lsp_capabilities()

          local servers = {
            rust_analyzer = {},
            clangd = {},
            lua_ls = {
                settings = {
                    Lua = {
                        completion = {
                          callSnippet = 'Replace',
                        },
                    },
                },
            },
          }

          for server_name, server_cfg in pairs(servers) do
            server_cfg.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_cfg.capabilities or {})
            vim.lsp.config(server_name, server_cfg)
            vim.lsp.enable(server_name)
          end
        '';
      }
      pkgs.vimPlugins.fidget-nvim
      {
        plugin = pkgs.vimPlugins.conform-nvim;
        type = "lua";
        config = ''
          local conform = require("conform")
          conform.setup({
              notify_on_error = false,
              format_on_save = function(bufnr)
                  -- Disable "format_on_save lsp_fallback" for languages that don't
                  -- have a well standardized coding style. You can add additional
                  -- languages here or re-enable it for the disabled ones.
                  local disable_filetypes = {
                      -- c = true,
                      -- cpp = true
                  }
                  if disable_filetypes[vim.bo[bufnr].filetype] then
                      return nil
                  else
                      return {
                          timeout_ms = 500,
                          lsp_format = 'fallback',
                      }
                  end
              end,
              formatters_by_ft = {
                  lua = { 'stylua' },
                  -- python = { "isort", "black" },
                  -- javascript = { "prettierd", "prettier", stop_after_first = true },
              },
          })

          vim.keymap.set({ "n", "v" }, "<leader>f", function()
              conform.format({ async = true, lsp_format = "fallback" })
          end, { desc = "[F]ormat buffer" })
        '';
      }
      {
        plugin = pkgs.vimPlugins.blink-cmp;
        # event = 'VimEnter',
        # version = '1.*',
        type = "lua";
        config = ''
          local blink = require("blink.cmp")

          blink.setup({
              keymap = {
                  preset = 'default',
              },
              appearance = {
                  nerd_font_variant = 'mono',
              },
              completion = {
                  documentation = { auto_show = false, auto_show_delay_ms = 500 },
                  list = {
                      selection = {
                          preselect = false,
                          auto_insert = true,
                      }
                  }
              },
              sources = {
                  default = { 'lsp', 'path', 'snippets', 'lazydev' },
                  providers = {
                      lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
                  },
              },
              snippets = { preset = 'luasnip' },
              fuzzy = { implementation = 'lua' },
              signature = { enabled = true },
          })
        '';
      }
      pkgs.vimPlugins.luasnip
      {
        plugin = pkgs.vimPlugins.todo-comments-nvim;
        type = "lua";
        config = ''
          require("todo-comments").setup({
              signs = false,
          })
        '';
      }
      pkgs.vimPlugins.plenary-nvim
      {
        plugin = pkgs.vimPlugins.mini-nvim;
        type = "lua";
        config = ''
          -- mini.ai
          require("mini.ai").setup({ n_lines = 500 })

          -- mini.surround
          require("mini.surround").setup()

          -- mini.statusline
          local statusline = require("mini.statusline")
          statusline.setup({ use_icons = vim.g.have_nerd_font })

          statusline.section_location = function()
              return "%2l:%-2v"
          end
        '';
      }
    ];
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
