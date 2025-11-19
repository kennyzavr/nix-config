{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkOption mkIf types;
  cfg = config.my.shell;
in {
  options.my.shell = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "enabl my ui shell tweaks";
    };

    idleTimeout = mkOption {
      type = types.ints.unsigned;
      default = 60;
      description = "screen lock timeout";
    };

    terminalBin = mkOption {
      type = types.str;
      default = "";
      description = "terminal binary path";
    };

    menuBin = mkOption {
      type = types.str;
      default = "";
      description = "menu binary path";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      wl-clipboard
      inter
      nerd-fonts.symbols-only
      brightnessctl
      swayidle
      shotman
      mako
    ];

    stylix.targets = {
      mako.enable = true;
      bemenu = {
        enable = true;
        alternate = true;
      };
      swaylock.enable = true;
      waybar = {
        enable = true;
        addCss = false;
      };
      sway.enable = true;
    };

    # programs.mako = {
    #   enable = true;
    # };

    programs.swaylock.enable = true;

    programs.bemenu = {
      enable = true;
      settings = {
        prompt = "Run:";
        list = "10 down";
        width-factor = 0.4;
        margin = 20;
        line-height = 22;
        binding = "vim";
        vim-esc-exits = true;
        center = true;
        ignorecase = true;
      };
    };

    programs.waybar = {
      enable = true;

      systemd = {
        enable = true;
        target = "sway-session.target";
      };

      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 10;

          # spacing = 0;

          modules-left = ["sway/workspaces"];
          modules-center = [];
          modules-right = [
            "network"

            "wireplumber#sink"

            "wireplumber#source"
            #
            # "memory"
            #
            # "cpu"

            # "temperature"

            # "battery"

            # "tray"

            "clock#date"

            "clock#time"

            "sway/language"
          ];

          margin-left = 8;
          margin-right = 8;

          "battery" = {
            interval = 10;
            states = {
              warning = 30;
              critical = 15;
            };

            format = "  {icon} {capacity}%";
            format-discharging = "{icon}  {capacity}%";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
            ];
            tooltip = true;
          };

          "wireplumber#sink" = {
            node-type = "Audio/Sink";
            format = "  {node_name} ({volume}%)";
          };
          "wireplumber#source" = {
            node-type = "Audio/Source";
            format = "  {node_name} ({volume}%)";
          };

          "clock#time" = {
            interval = 10;
            format = "󱑂  {:%H:%M}";
            tooltip-format = "| {:%H:%M}";
          };

          "clock#date" = {
            interval = 10;
            format = "  {:%e %b %Y}";
            tooltip-format = "{:%e %B %Y}";
          };

          "cpu" = {
            interval = 5;
            format = "  {usage}%";
            "states" = {
              warning = 70;
              critical = 90;
            };
          };

          "memory" = {
            interval = 5;
            format = "  {}%";
            states = {
              warning = 70;
              critical = 90;
            };
          };

          "sway/language" = {
            format = "󰌌  {short}";
            max-length = 100;
          };

          "network" = {
            interval = 5;
            format-wifi = "{icon}  {essid} ({signalStrength}%)";
            format-icons = [""];
            format-ethernet = " {ifname}: {ipaddr}/{cidr}";
            format-disconnected = "⚠  Disconnected";
            tooltip-format = "{ifname}: {ipaddr}";
          };

          "sway/window" = {
            format = "{}";
            max-length = 120;
          };

          "sway/workspaces" = {
            all-outputs = false;
            disable-scroll = true;
            format = "{name}";
            format-icons = {
              "urgent" = "";
              "focused" = "";
              "default" = "";
            };
          };

          "temperature" = {
            "critical-threshold" = 80;
            "interval" = 5;
            "format" = "{icon} {temperatureC}°C";
            "format-icons" = [
              ""
              ""
              ""
              ""
              ""
            ];
            "tooltip" = true;
          };

          "tray" = {
            "icon-size" = 21;
            "spacing" = 10;
          };
        };
      };

      style = ''
        * {
          color: @base05;
          margin: 0;
          padding: 0;
          transition: none;
          animation: none;
        }

        window#waybar {
          background-color: @base00;
        }

        .modules-right .module {
          border-left: 1px solid @base02;
        }

        .module {
          padding-left: 1em;
          padding-right: 1em;
        }

        .modules-center {
          min-width: 0;
        }

        #workspaces {
          padding: 0;
        }

        #workspaces button {
          border-radius: 0;
          box-shadow: none;
          padding: 0 0.5em;
          border: 1px solid @base02;
        }

        #workspaces button label {
          font-weight: 400;
          color: @base05;
        }

        #workspaces button.focused {
          border-color: @base0D;
        }

        #workspaces button.visible:not(.focused) {
          border-color: @base04;
        }

        #workspaces button.urgent {
          border-color: @base08;
        }
      '';
    };

    wayland.windowManager.sway = let
      colors = config.lib.stylix.colors;
    in {
      enable = true;
      systemd.enable = true;
      wrapperFeatures.gtk = true;

      config = rec {
        modifier = "Mod4";
        terminal = cfg.terminalBin;
        menu = cfg.menuBin;

        gaps = {
          inner = 8;
          outer = 8;
          smartGaps = true;
        };

        input."*" = {
          xkb_layout = "us,ru";
          xkb_options = "grp:win_space_toggle,caps:ctrl_modifier";
        };

        bars = [
        ];

        startup = [
          {
            command = "lxqt-policykit-agent";
          }
          {
            command = ''
              ${pkgs.swayidle}/bin/swayidle -w \
                timeout ${builtins.toString cfg.idleTimeout} '${config.programs.swaylock.package}/bin/swaylock -f' \
                before-sleep '${config.programs.swaylock.package}/bin/swaylock -f'
            '';
          }
        ];

        keybindings = {
          "${modifier}+Return" = "exec ${terminal}";
          "${modifier}+Shift+q" = "kill";

          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";

          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";

          "${modifier}+Control+h" = "resize shrink width 10px";
          "${modifier}+Control+l" = "resize grow width 10px";
          "${modifier}+Control+j" = "resize grow height 10px";
          "${modifier}+Control+k" = "resize shrink height 10px";

          "${modifier}+v" = "splitv";
          "${modifier}+s" = "splith";

          "${modifier}+f" = "fullscreen";
          "${modifier}+Shift+space" = "floating toggle";

          "${modifier}+g" = "layout tabbed";
          "${modifier}+Shift+g" = "layout stacking";
          "${modifier}+e" = "layout toggle split";

          "${modifier}+1" = "workspace number 1";
          "${modifier}+2" = "workspace number 2";
          "${modifier}+3" = "workspace number 3";
          "${modifier}+4" = "workspace number 4";
          "${modifier}+5" = "workspace number 5";
          "${modifier}+6" = "workspace number 6";
          "${modifier}+7" = "workspace number 7";
          "${modifier}+8" = "workspace number 8";
          "${modifier}+9" = "workspace number 9";

          "${modifier}+Shift+1" = "move container to workspace number 1";
          "${modifier}+Shift+2" = "move container to workspace number 2";
          "${modifier}+Shift+3" = "move container to workspace number 3";
          "${modifier}+Shift+4" = "move container to workspace number 4";
          "${modifier}+Shift+5" = "move container to workspace number 5";
          "${modifier}+Shift+6" = "move container to workspace number 6";
          "${modifier}+Shift+7" = "move container to workspace number 7";
          "${modifier}+Shift+8" = "move container to workspace number 8";
          "${modifier}+Shift+9" = "move container to workspace number 9";

          "${modifier}+p" = "exec ${menu}";

          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+e" = "exit";

          "XF86AudioRaiseVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioLowerVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "XF86AudioMute" = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "XF86AudioMicMute" = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl} set 10%+";
          "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl} set 10%-";

          "${modifier}+b" = "exec ${config.programs.swaylock.package}/bin/swaylock -f";

          "Print" = "exec ${pkgs.shotman}/bin/shotman region";
          "${modifier}+Shift+s" = "exec ${pkgs.shotman}/bin/shotman --capture region --copy";
        };
      };
    };
  };
}
