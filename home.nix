{ config, pkgs, ... }:

{
  home.username = "to";
  home.homeDirectory = "/home/to";
  home.stateVersion = "24.05"; 

  # Enable Kitty
  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      background_opacity = "0.9";
    };
  };

  # Enable Rofi
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
  };

  # Enable and configure Waybar
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "cpu" "memory" "tray" ];

        clock = {
          format = "{:%Y-%m-%d %H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        cpu = {
          format = "CPU {usage}%";
        };
        memory = {
          format = "RAM {}%";
        };
        network = {
          format-wifi = "WiFi {signalStrength}%";
          format-ethernet = "Eth {ipaddr}";
          format-disconnected = "Disconnected";
        };
        pulseaudio = {
          format = "Vol {volume}%";
          format-muted = "Muted";
        };
      };
    };
  };

  # Git settings
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "tolemariamfufat";
        email = "tolemariamfufat@gmail.com";
      };
    };
  };

  programs.home-manager.enable = true;
}
