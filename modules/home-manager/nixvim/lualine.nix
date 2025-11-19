{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.nixvim = {
    plugins = {
      lualine = {
        enable = true;

        settings = {
          options = {
            theme = "auto"; # подхватит цвета от темы / stylix
            icons_enabled = true;

            globalstatus = true; # одна общая статус-линия на все окна (nvim >= 0.7)
            component_separators = {
              left = "";
              right = "";
            };
            section_separators = {
              left = "";
              right = "";
            };

            disabled_filetypes = {
              statusline = [
                "neo-tree"
                "TelescopePrompt"
                "lazy"
                "dap-repl"
              ];
              winbar = [];
            };
          };

          sections = {
            lualine_a = ["mode"];
            lualine_b = ["branch" "diff" "diagnostics"];
            lualine_c = [
              {
                __unkeyed = "filename";
                file_status = true; # +/- для модифицированного файла
                path = 1; # 0 = имя, 1 = относительный путь, 2 = абсолютный
              }
            ];

            lualine_x = ["encoding" "fileformat" "filetype"];
            lualine_y = ["progress"]; # % по файлу
            lualine_z = ["location"]; # строка/колонка
          };

          inactive_sections = {
            lualine_a = [];
            lualine_b = [];
            lualine_c = [
              {
                __unkeyed = "filename";
                file_status = true;
                path = 0;
              }
            ];
            lualine_x = ["location"];
            lualine_y = [];
            lualine_z = [];
          };

          tabline = {};
          winbar = {};
          inactive_winbar = {};

          extensions = [
            "neo-tree"
            "quickfix"
            "fugitive"
            "man"
          ];
        };
      };
    };
  };
}
