{config, pkgs, lib,...}:
with lib;
{


  options.host.desktop.waybar = mkEnableOption "Enable Waybar";


  config = mkIf config.host.desktop.waybar {


    wayland.windowManager.hyprland.settings.exec-once = [ "${pkgs.waybar}/bin/waybar"];
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          output = ["eDP-1" "Acer Technologies VG270U P TEHEE00A854F"];
          position = "top";
          height = 28;
          exclusive = true;
          modules-left = ["custom/nixos" "hyprland/workspaces" "tray" ];
          modules-center = ["hyprland/window"];
          modules-right = [ "cpu" "memory" "disk" "network" "hyprland/language" "group/light" "wireplumber" "idle_inhibitor" "battery" "clock"];

          "group/light" = {

            modules = [ "backlight" "backlight/slider"];
            orientation = "inherit";

            drawer = {
              transition-duration = 500;
              transition-left-to-right = false;
              children-css = "";

            };
          };

          "backlight" = {
            interval = 3;
            format = "{icon} {percent}%";
            format-icons = [ "󰹐 " "󱩎 " "󱩏 " "󱩐 " "󱩑 " "󱩒 " "󱩓 " "󱩔 " "󱩕 " "󱩖 " ];
            tooltip = false;
            device = "amdgpu_bl1";
          };

          "backlight/slider" = {
            min = 0;
            max = 100;
            orientation = "horizontal";
            device = "amdgpu_bl1";

          };


          "network" = {

            interval = 30;

            format-wifi = " ";

            format-ethernet = "󰈀 ";

            format-disconnected = "󰌙 ";

            tooltip = true;
            tooltip-format-wifi = "{essid}: {bandwidthUpBytes}/{bandwidthDownBytes}";
            tooltip-format-ethernet = "{ifname}: {bandwidthUpBytes}/{bandwidthDownBytes}";

          };
          "custom/nixos" = {
            format = " ";
            on-click = "hyprctl dispatch overview:toggle";
          };

          "hyprland/language" = {
            format = "{short}";
          };

          "hyprland/window" = {
            rewrite = {
              "nvim\\s*" = " eovim - the best Editor";
              "nvim (\\S.*)" = "  - $1";
              "(.*)- GNU Emacs at (.*)" = " { $2 } - $1 " ;
              "(.*)— Mozilla Firefox" = " - $1";
              "(.*)- Mozilla Thunderbird" = "  - $1";
              "nix-shell -p (.*)" = "  +   { $1 }";
            };
          };

          "wireplumber" = {

            format = "{icon} {volume}%";

            format-muted = " {volume}%";

            format-icons = ["" " " " "];

            on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";


            tooltip = true;
            tooltip-format = "{node_name}: {volume}%";
          };

          "idle_inhibitor" = {
            format = "{icon}";
            format-icons = {
              deactivated = " ";
              activated = " ";
            };

          };

          "cpu" = {
            interval = 5;
            format = "  {}%";
            max-length = 10;

            states = {
              critical = 80;
              moderate = 20;
            };
          };

          "memory" = {
            format = "  {percentage}%";
            tooltip = true;
            tooltip-format = "{used:0.1f}G/{total:0.1f}G";
          };

          "disk" = {
            format = "󱛟 {percentage_used}%";
            unit = "Gb";
            tooltip = true;
            tooltip-format = "{used}/{total}";
            states = {
              empty = 25;
              halfway = 50;

            };

          };


          "tray" = {
            spacing = 5;
            show-passive-items = true;
          };

          "hyprland/workspaces" = {
            all-outputs = true;
            special-visible-only = true;
            move-to-monitor = true;
          };

          "clock" = {
            actions = {
              on-click-right = "mode";
              on-scroll-up = "tz_up";
              on-scroll-down = "tz_down";
            };
            tooltip = true;
            tooltip-format = "<tt><small>{calendar}</small></tt>";
            calendar = {
              mode = "year";
              weeks-pos = "right";
              on-scroll = 1;
              mode-mon-col = 3;
              format = {
                months = "<span color='${config.scheme.withHashtag.base06}'><b>{}</b></span>";
                days = "<span color='${config.scheme.withHashtag.base03}'><b>{}</b></span>";
                weeks = "<span color='${config.scheme.withHashtag.base0B}'><b>W{}</b></span>";
                weekdays = "<span color='${config.scheme.withHashtag.base13}'><b>{}</b></span>";
                today = "<span color='${config.scheme.withHashtag.base17}'><b>{}</b></span>";
              };
            };
          };

          "battery" = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{icon} {capacity}%";
            format-icons = [" "  " "  " "  " "  " "];
            max-length = 25;
          };
        };

      };


      style = let col = config.scheme.withHashtag;  in ''

@define-color base00 ${col.base00};
@define-color base01 ${col.base01};
@define-color base02 ${col.base02};
@define-color base03 ${col.base03};
@define-color base04 ${col.base04};
@define-color base05 ${col.base05};
@define-color base06 ${col.base06};
@define-color base07 ${col.base07};
@define-color base08 ${col.base08};
@define-color base09 ${col.base09};
@define-color base0A ${col.base0A};
@define-color base0B ${col.base0B};
@define-color base0C ${col.base0C};
@define-color base0D ${col.base0D};
@define-color base0E ${col.base0E};
@define-color base0F ${col.base0F};
@define-color base10 ${col.base10};
@define-color base11 ${col.base11};
@define-color base12 ${col.base12};
@define-color base13 ${col.base13};
@define-color base14 ${col.base14};
@define-color base15 ${col.base15};
@define-color base16 ${col.base16};
@define-color base17 ${col.base17};

        * {
        all: unset;
        font-family: "Mononoki Nerd Font";
        }

        tooltip,
        #tray menu {
        background-color: @base01;
        border-radius: 4px;
        padding: 4px;
        margin-top: 1em;
        }

        #cpu,
        #wireplumber,
        #clock,
        #battery,
        #idle_inhibitor,
        #tray,
        #disk,
        #memory,
        #light,
        #network,
        #backlight,
        #backlight-slider,
        #language {
        padding-left: 6px;
        margin-top: 2px;
        background-color: @base01;
        }

        window#waybar {
        background: transparent;
        margin: 5px;
        }

        .modules-right {
        padding-left: 8px;
        margin-top: 2px;
        }

        .modules-center {
        padding: 0 15px;
        margin-top: 2px;
        border-radius: 15px 15px 15px 15px;
        background-color: @base01;
        transition: all 0.3s ease-out;
        }

        .modules-left {
        padding-right: 8px;
        border-radius: 0 15px 15px 0;
        margin-top: 2px;
        transition: all 0.3s ease-out;
        }

        #workspaces {
        background-color: @base01;
        padding-left: 4px;

        border-radius: 0 15px 15px 0;
        }

        #workspaces button {
        padding: 0 4px;
        margin: 2px;
        color: @base03;
        transition: all 0.3s ease-out;
        animation: linear 20s ease-in infinite;
        }

        #workspaces button.empty {
        color: @base03;
        }

        #workspaces button.visible {
        color: @base0D;
        }
        #workspaces button.active {
        color: @base0A;
        }

        #workspaces button.urgent {
        color: @base0F;
        }



        #idle_inhibitor.activated {
        color: @base0D;
        transition: all 0.3s ease-in
        }

        #idle_inhibitor.deactivated {
        color: @base03;
        transition: all 0.3s ease-out
        }

        #network {

        border-radius: 0 15px 15px 0;
        margin-right: 3em;
        padding-right: 6px;
        }

        #network.disconnected {
        color: @base03;
        }

        #network.wifi, #network.ethernet {
        color: @base0D;
        }

        #tray menu menuitem:hover {
        background-color: @base02;
        color: @base0E;
        
        }

        #tray menu *:hover {
        background-color: @base01;
        color: inherit;
        }

        #cpu {
        border-radius: 15px 0 0 15px;
        }

        #cpu.moderate{
        color: @base0E;
        }
        #cpu.critical {
        color: @base08;
        }

        #window {
        background-color: @base01;
        transition-property: all;
        transition-duration: 0.5s;
        transition-timing-function: ease;
        }

        window#waybar.empty #window, window#waybar.empty .modules-center  {
        background-color: transparent;
        background: transparent;
        }

        #tray {
        background-color: @base01;
        padding-left: 8px;
        padding-right: 8px;
        margin-left: 3em;

        border-radius: 15px 15px 15px 15px;

        }

        #tray > .passive {
        -gtk-icon-effect: dim;
        }

        #language {
        border-radius: 15px 0 0 15px;
        }

        #custom-nixos {
        padding-left: 4px;
        background-color: @base01;
        }

        #clock {
        background-color: @base01;
        }

        #wireplumber {

        transition: all 0.3s ease-in
        }

        #wireplumber.muted {
        color: @base03;

        transition: all 0.3s ease-out
        }

        #battery {
        background-color: @base01;
        }

        #battery.warning {
        color: @base08;
        }

        #battery.critical {
        animation-name: blink;
        animation-duration: 1s;
        animation-timing-function: ease-out;
        animation-iteration-count: infinite;
        animation-direction: alternate;
        }

        @keyframes blink {
        to {
        color: @base01;
        }
        }



        #backlight-slider {
        padding-left: 6px;
        min-width: 80px;
        min-height: 5px;

        }
        #backlight-slider slider {
        min-height: 0px;
        min-width: 0px;
        opacity: 0;
        background-image: none;
        border: none;
        box-shadow: none;
        }


        #backlight-slider through {
        min-width: 80px;
        border-radius: 5px;
        background-color: @base03;
        min-height: 5px;
        }

        #backlight-slider highlight {
        min-width: 80px;
        min-height: 5px;
        border-radius: 5px;
        background-color: @base13;
        color: @base0E;
        }
    '';


    };
  };
}
