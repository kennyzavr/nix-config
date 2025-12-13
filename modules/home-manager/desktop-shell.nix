{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkOption mkIf types;
  cfg = config.desktop-shell;
in {
  options.desktop-shell = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "enable desktop shell tweaks";
    };

    terminalBin = mkOption {
      type = types.str;
      default = "";
      description = "terminal binary path";
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
      libnotify
      xwayland-satellite
      adwaita-icon-theme
    ];

    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };
    #home.file.".icons/default".source = "${pkgs.vanilla-dmz}/share/icons/Vannilla-DMZ";

    services.lxqt-policykit-agent.enable = true;

    xdg.portal = {
      enable = true;

      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-wlr
      ];

      config.common.default = "*";
      config.common."org.freedesktop.impl.portal.ScreenCast" = ["wlr"];
    };

    stylix.fonts.sizes = {
      desktop = 12;
      applications = 12;
      terminal = 12;
    };

    stylix.opacity = {
      applications = 1.0;
      terminal = 1.0;
    };

    stylix.targets.swaylock.enable = true;
    programs.swaylock.enable = true;
    services.swayidle = let
      lock = "${pkgs.swaylock}/bin/swaylock";
      notify = "${pkgs.libnotify}/bin/notify-send";
      niriAction = "${pkgs.niri}/bin/niri msg action";
      sctl = "${pkgs.systemd}/bin/systemctl";
    in {
      enable = true;
      systemdTarget = "graphical-session.target";
      events = [
        {
          event = "before-sleep";
          command = "${niriAction} power-off-monitors; ${lock} -fF";
        }
        {
          event = "after-resume";
          command = "${niriAction} power-on-monitors";
        }
        {
          event = "lock";
          command = "${lock} -fF";
        }
        {
          event = "unlock";
          command = "${niriAction} power-on-monitors";
        }
      ];
      timeouts = [
        {
          timeout = 80;
          command = "${notify} -u normal 'Locking soon' 'Screen will lock in 10 seconds'";
        }
        {
          timeout = 90;
          command = "${lock} -fF";
        }
        {
          timeout = 100;
          command = "${niriAction} power-off-monitors";
          resumeCommand = "${niriAction} power-on-monitors";
        }
        {
          timeout = 180;
          command = "${sctl} suspend";
        }
      ];
    };

    stylix.targets.mako.enable = true;
    services.mako.enable = true;
    services.mako.settings = {
      default-timeout = 5000;
      ignore-timeout = true;
    };

    stylix.targets.fuzzel.enable = true;
    programs.fuzzel.enable = true;
    programs.fuzzel.settings = {
      border = {
        width = 4;
        radius = 0;
      };
    };

    stylix.targets.waybar.enable = false;
    programs.waybar.enable = true;
    programs.waybar.systemd = {
      enable = true;
      target = "graphical-session.target";
    };
    programs.waybar.settings.mainBar = let
      icons = rec {
        calendar = "󰃭 ";
        clock = " ";

        network.disconnected = "󰤮 ";
        network.ethernet = "󰈀 ";
        network.strength = [
          "󰤟 "
          "󰤢 "
          "󰤥 "
          "󰤨 "
        ];

        volume.source = "";
        volume.muted = "󰝟";
        volume.levels = [
          "󰕿"
          "󰖀"
          "󰕾"
        ];

        idle.on = "󰈈 ";
        idle.off = "󰈉 ";

        notification.red-badge = "<span foreground='red'><sup></sup></span>";
        notification.bell = "󰂚";
        notification.bell-badge = "󱅫";
        notification.bell-outline = "󰂜";
        notification.bell-outline-badge = "󰅸";

        memory = " ";

        keyboard = "󰌌 ";
      };
    in {
      layer = "top";

      modules-left = [
        "niri/workspaces"
        "niri/window"
      ];

      modules-center = [
        "clock#date"
        "clock#time"
      ];

      modules-right = [
        "network"
        "wireplumber#sink"
        "wireplumber#source"
        "memory"
        "niri/language"
        "idle_inhibitor"
        "tray"
      ];

      margin-top = 8;
      margin-bottom = 12;
      margin-right = 10;
      margin-left = 10;

      "wireplumber#sink" = {
        node-type = "Audio/Sink";
        format = "{icon} {node_name} {volume}%";
        format-muted = "${icons.volume.muted} {node_name} {volume}%";
        format-icons = icons.volume.levels;
        reverse-scrolling = 1;
        tooltip = false;
      };

      "wireplumber#source" = {
        node-type = "Audio/Source";
        format = "${icons.volume.source} {node_name} {volume}%";
        tooltip = false;
      };

      "clock#time" = {
        interval = 1;
        format = "${icons.clock} {:%H:%M:%S}";
        tooltip = false;
      };

      "clock#date" = {
        format = "${icons.calendar} {:%d-%m-%Y}";
        tooltip = false;
      };

      "memory" = {
        interval = 5;
        format = "${icons.memory} {}%";
        states = {
          warning = 70;
          critical = 90;
        };
        tooltip = false;
      };

      "network" = {
        format-wifi = "{icon} {essid} {signalStrength}%";
        format-icons = icons.network.strength;
        format-ethernet = icons.network.ethernet;
        format-disconnected = icons.network.disconnected;
        tooltip = false;
      };

      "tray" = {
        "icon-size" = 14;
        "spacing" = 10;
        tooltip = false;
      };

      "niri/language" = {
        format = "${icons.keyboard} {short}";
        max-length = 100;
        tooltip = false;
      };

      "niri/window" = {
        format = "{}";
        max-length = 120;
        tooltip = false;
      };

      "niri/workspaces" = {
        all-outputs = false;
        disable-scroll = true;
        format = "{}";
        tooltip = false;
      };

      "idle_inhibitor" = {
        "format" = "{icon}";
        "format-icons" = {
          "activated" = icons.idle.on;
          "deactivated" = icons.idle.off;
        };
        "timeout" = 9999;
        "tooltip" = false;
      };
    };
    programs.waybar.style = let
      colors = config.lib.stylix.colors;
    in ''
      * {
          border: none;
          font-family: ${config.stylix.fonts.sansSerif.name};
          font-size: ${toString config.stylix.fonts.sizes.desktop}px;
          color: #${colors.base07};
      }

      window#waybar {
          background: #${colors.base00};
      }

      .modules-left, .modules-center, .modules-right {
        padding: 0.5em;
      }
      .module {
          padding: 0 0.5em;
      }

      #workspaces button {
          color: #${colors.base04};
          background: #${colors.base01};
          margin: 0.2em;
          padding: 0px 0.5em;
          /*border-radius: 0.35em;*/
          border-radius: 0;
          font-weight: 500;
      }
      #workspaces button:hover {
          color: #${colors.base04};
          background: #${colors.base01};
          box-shadow: none;
          border: 0;
          transition: 0;
          font-weight: 500;
      }
      #workspaces button.active {
          background: #${colors.base03};
          color: #${colors.base07};
      }
      #workspaces button.focused {
          background: #${colors.base0B};
          color: #${colors.base00};
      }
      #workspaces button.urgent {
          border: solid 2px #${colors.base08};
          /*color: #${colors.base00};*/
      }
      #workspaces button.empty {
          background: transparent;
          color: #${colors.base03};
      }
    '';

    programs.niri.enable = true;
    programs.niri.package = pkgs.niri;
    programs.niri.settings = {
      prefer-no-csd = true;

      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

      hotkey-overlay = {
        hide-not-bound = true;
        skip-at-startup = true;
      };

      clipboard = {
        disable-primary = true;
      };

      spawn-at-startup = [];

      input = {
        mod-key = "Super";
      };

      outputs."HDMI-A-1" = {
        focus-at-startup = true;
        position = {
          x = 0;
          y = 0;
        };
        scale = 1;
        mode = {
          width = 1920;
          height = 1080;
          refresh = 120.000;
        };
      };
      outputs."eDP-1" = {
        position = {
          x = 1920;
          y = 0;
        };
        scale = 1;
      };

      cursor.hide-after-inactive-ms = 2000;
      cursor.theme = "Adwaita";
      cursor.size = 24;

      environment."NIXOS_OZONE_WL" = "1";

      layout.gaps = 16;
      layout.struts = {
        bottom = 0;
        top = -16;
        left = 0;
        right = 0;
      };
      layout.focus-ring.active = {
        color = config.lib.stylix.colors.base0D;
      };
      layout.always-center-single-column = true;

      input.keyboard.xkb.layout = "us,ru";
      input.keyboard.xkb.options = "grp:win_space_toggle,caps:ctrl_modifier";

      window-rules = [
        {
          matches = [
            {
              title = "Authentication Required";
            }
          ];
          open-floating = true;
        }
      ];

      binds = with config.lib.niri.actions; {
        "Mod+H".action = focus-column-left;
        "Mod+L".action = focus-column-right;
        "Mod+J".action = focus-window-down;
        "Mod+K".action = focus-window-up;
        "Mod+Ctrl+H".action = move-column-left;
        "Mod+Ctrl+L".action = move-column-right;
        "Mod+Ctrl+J".action = move-window-down;
        "Mod+Ctrl+K".action = move-window-up;

        "Mod+Shift+H".action = focus-monitor-left;
        "Mod+Shift+L".action = focus-monitor-right;
        "Mod+Shift+J".action = focus-monitor-down;
        "Mod+Shift+K".action = focus-monitor-up;
        "Mod+Shift+Ctrl+H".action = move-column-to-monitor-left;
        "Mod+Shift+Ctrl+L".action = move-column-to-monitor-right;
        "Mod+Shift+Ctrl+J".action = move-column-to-monitor-down;
        "Mod+Shift+Ctrl+K".action = move-column-to-monitor-up;

        "Mod+P".action = focus-workspace-up;
        "Mod+N".action = focus-workspace-down;
        "Mod+Shift+P".action = move-workspace-up;
        "Mod+Shift+N".action = move-workspace-down;
        "Mod+Ctrl+P".action = move-column-to-workspace-up;
        "Mod+Ctrl+N".action = move-column-to-workspace-down;

        "Mod+1".action = focus-workspace 1;
        "Mod+2".action = focus-workspace 2;
        "Mod+3".action = focus-workspace 3;
        "Mod+4".action = focus-workspace 4;
        "Mod+5".action = focus-workspace 5;
        "Mod+6".action = focus-workspace 6;
        "Mod+7".action = focus-workspace 7;
        "Mod+8".action = focus-workspace 8;
        "Mod+9".action = focus-workspace 9;
        "Mod+Ctrl+1".action.move-column-to-workspace = 1;
        "Mod+Ctrl+2".action.move-column-to-workspace = 2;
        "Mod+Ctrl+3".action.move-column-to-workspace = 3;
        "Mod+Ctrl+4".action.move-column-to-workspace = 4;
        "Mod+Ctrl+5".action.move-column-to-workspace = 5;
        "Mod+Ctrl+6".action.move-column-to-workspace = 6;
        "Mod+Ctrl+7".action.move-column-to-workspace = 7;
        "Mod+Ctrl+8".action.move-column-to-workspace = 8;
        "Mod+Ctrl+9".action.move-column-to-workspace = 9;

        "Mod+Q".action = close-window;

        "Mod+R".action = switch-preset-column-width;
        "Mod+M".action = maximize-column;
        "Mod+F".action = fullscreen-window;
        "Mod+Shift+F".action = toggle-windowed-fullscreen;
        "Mod+C".action = center-column;

        "Mod+Minus".action = set-column-width "-10%";
        "Mod+Equal".action = set-column-width "+10%";
        "Mod+Shift+Minus".action = set-window-height "-10%";
        "Mod+Shift+Equal".action = set-window-height "+10%";

        # "Mod+S".action = clear-dynamic-cast-target;
        # "Mod+S+W".action = set-dynamic-cast-window;
        # "Mod+S+M".action = set-dynamic-cast-monitor;

        "Mod+Shift+E".action = quit {
          skip-confirmation = true;
        };

        "Mod+Shift+Slash".action = show-hotkey-overlay;

        "Mod+Ctrl+V".action = toggle-window-floating;
        "Mod+V".action = switch-focus-between-floating-and-tiling;

        "Mod+T".action = spawn ["${cfg.terminalBin}"];
        "Mod+D".action = spawn ["${pkgs.fuzzel}/bin/fuzzel"];

        "Mod+Comma".action = consume-window-into-column;
        "Mod+Period".action = expel-window-from-column;

        "Mod+Shift+S".action.screenshot = [];
        "Mod+O".action.toggle-overview = [];

        "Mod+B".action = spawn ["${pkgs.swaylock}/bin/swaylock" "-fF"];

        "XF86AudioRaiseVolume".action = spawn ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"];
        "XF86AudioLowerVolume".action = spawn ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"];
        "XF86AudioMute".action = spawn ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
        "XF86AudioMicMute".action = spawn ["wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"];
      };

      debug = {
        deactivate-unfocused-windows = [];
      };
    };
  };
}
