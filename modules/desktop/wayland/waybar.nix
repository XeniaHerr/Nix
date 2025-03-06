{config, pkgs, lib,...}:
  with lib;
{


  options.host.desktop.waybar = mkEnableOption "Enable Waybar";


  config = mkIf config.host.desktop.waybar {


    wayland.windowManager.hyprland.settings.exec-once = [ "${pkgs.waybar}"];
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          output = ["eDP-1" "DP-12"];
          position = "top";
          height = 28;
          modules-left = ["custom/nixos" "hyprland/workspaces"];
          modules-center = ["hyprland/window"];
          modules-right = [ "hyprland/language" "cpu" "battery" "clock" "tray"];

          "custom/nixos" = {
            format = " ";
            on-click = "hyprctl dispatch overview:toggle";
          };

          "hyprland/language" = {
            format = "{short}";
          };

          "hyprland/window" = {
            rewrite = {
              "nvim (.*)" = "  - $1";
              "(.*)— Mozilla Firefox" = " - $1";
              "(.*)- Mozilla Thunderbird" = "  - $1";
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
            tooltop-format = "{:%Y-%m-%d}";
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

        window#waybar {
        background: transparent;
        margin: 5px;
        }

        .modules-right {
        padding-left: 8px;
        border-radius: 15px 0 0 15px;
        margin-top: 2px;
        background-color: @base01;
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
        background-color: @base01;
        }

        #workspaces {
        background-color: @base01;
        margin: 2px;

        border-radius: 4px;
        }

        #workspaces button {
        padding: 0 4px;
        margin: 2px;
        color: @base06;
        }

        #workspaces button.empty {
        color: @base06;
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

        #cpu {
        padding-left: 4px;
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
        padding-left: 4px;

        }


        #custom-nixos {
        padding-left: 4px;
        padding-right: 4px;
        }

        #clock {
        background-color: @base01;
        padding-left: 4px;
        }

        #battery {
        background-color: @base01;
        padding-left: 4px;
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
    '';


    };
  };
}
