{ config, pkgs, ... }:

{
  home.username = "to";
  home.homeDirectory = "/home/to";
  home.stateVersion = "24.05"; 

  # MANDATORY FOR FONTS TO WORK IN HM:
  # Discovers fonts installed in home.packages and builds fc-cache
  fonts.fontconfig.enable = true;

  # Disable Home Manager's systemd integration to prevent conflict with UWSM
  wayland.windowManager.hyprland.systemd.enable = false;

  # User packages
  home.packages = with pkgs; [
    pavucontrol # Audio volume GUI
    
    # Updated nerd-fonts syntax for current nixpkgs:
    nerd-fonts.jetbrains-mono
  ];

  # Enable Kitty Terminal
  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      background_opacity = "0.9";
    };
  };

  # Enable Rofi with permanent Monokai theme
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    theme = "Monokai";
  };

  # Enable and style Waybar Status Bar
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 36;
        margin-top = 8;
        margin-left = 12;
        margin-right = 12;

        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "cpu" "memory" "battery" "tray" ];

        "hyprland/workspaces" = {
          format = "{id}";
          on-click = "activate";
        };

        "hyprland/window" = {
          max-length = 30;
          separate-outputs = true;
        };

        clock = {
          format = "  {:%H:%M}";
          format-alt = "  {:%A, %B %d, %Y}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ff99'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc00'><b>{}</b></span>";
              today = "<span color='#ff6666'><b><u>{}</u></b></span>";
            };
          };
        };

        cpu = {
          format = " {usage}%";
        };

        memory = {
          format = " {percentage}%";
        };

        network = {
          format-wifi = " {essid}";
          format-ethernet = "󰈀 Wired";
          format-disconnected = "󰤮 Offline";
          tooltip-format = "{ifname} ({ipaddr})";
        };

        pulseaudio = {
          format = "󰕾 {volume}%";
          format-muted = "󰝟 Muted";
          on-click = "pavucontrol";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{time} {icon}";
          format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        };

        tray = {
          spacing = 10;
        };
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font", "Font Awesome 6 Free", sans-serif;
        font-weight: bold;
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
      }

      #workspaces,
      #window,
      #clock,
      #pulseaudio,
      #network,
      #cpu,
      #memory,
      #battery,
      #tray {
        background: rgba(20, 20, 26, 0.85);
        color: #cdd6f4;
        padding: 4px 14px;
        margin: 2px 4px;
        border-radius: 20px;
        border: 1px solid rgba(255, 255, 255, 0.1);
      }

      #workspaces button {
        padding: 0 5px;
        color: #6c7086;
        border-radius: 12px;
      }

      #workspaces button.active {
        color: #cba6f7;
      }

      #workspaces button:hover {
        background: rgba(255, 255, 255, 0.1);
        color: #f5e0dc;
      }

      #clock { color: #89b4fa; }
      #pulseaudio { color: #a6e3a1; }
      #network { color: #f9e2af; }
      #cpu { color: #f38ba8; }
      #memory { color: #fab387; }
      #window { color: #bac2de; font-weight: normal; }

      #battery { color: #a6e3a1; }
      #battery.charging, #battery.plugged { color: #a6e3a1; }
      #battery.warning { color: #f9e2af; }
      #battery.critical:not(.charging) {
        color: #f38ba8;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }
    '';
  };

  # Git Configuration
  programs.git = {
    enable = true;
    userName = "tolemariamfufat";
    userEmail = "tolemariamfufat@gmail.com";
  };

  # Enable Home Manager self-management
  programs.home-manager.enable = true;
}
