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
          modules-left = ["custom/nixos" "hyprland/workspaces" "tray" ];
          modules-center = ["hyprland/window"];
          modules-right = [ "cpu" "memory" "disk" "network" "hyprland/language" "backlight" "wireplumber" "idle_inhibitor" "battery" "clock"];

          "group/light" = {

            modules = [ "backlight" "backlight/slider"];

            drawer = {
              transition-duration = 500;
              transition-left-to-right = false;
              children-css = "light";

            };
          };

          "backlight" = {
            interval = 3;
            format = "{icon} {percent}%";
            format-icons = [ "󰹐 " "󱩎 " "󱩏 " "󱩐 " "󱩑 " "󱩒 " "󱩓 " "󱩔 " "󱩕 " "󱩖 " ];
            tooltip = false;
          };

          "backlight/slider" = {
            min = 0;
            max = 255;
            orientation = "horizontal";

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
              "nvim" = " eovim - the best Editor";
              "nvim (.*)" = "  - $1";
              "(.*)— Mozilla Firefox" = " - $1";
              "(.*)- Mozilla Thunderbird" = "  - $1";
              "nix-shell -p (.*)" = "  +   { $1 }";
            };
          };

          "wireplumber" = {

            format = "{icon} {volume}%";

            format-icons = ["" " " " "];

            on-click-right = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";


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
            };
            tooltip = true;
            tooltip-format = "{:%Y-%m-%d}";
            calendar = {
              mode = "month";
              weeks-pos = "left";
              on-scroll = 1;
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

        .tooltip * {

        background-color: @base01;
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
        transition-property: all;
        transition-duration: 0.5s;
        transition-timing-function: ease;
        }

        .modules-left{
        padding-right: 8px;
        border-radius: 0 15px 15px 0;
        margin-top: 2px;
        transition-property: all;
        transition-duration: 0.5s;
        transition-timing-function: ease;
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
        }

        #idle_inhibitor.deactivated {
        color: @base03;
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


        #disk {

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

        }
        #backlight-slider slider {
        min-width: 0px;

        }


        #backlight-slider through {
        min-width: 80px;
        border-radius: 5px;
        background-color: @base03;
        min-height: 10px;
        }

        #backlight-slider highlight {
        min-width: 10px;
        border-radius: 5px;
        background-color: @base13;
        }
    '';


    };
  };
}
