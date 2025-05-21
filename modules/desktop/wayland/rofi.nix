{config, pkgs, lib, inputs,  ...}:
with lib;
{

  
  config = {

    home.packages = with pkgs; [
      rofi-wayland
    ];

    wayland.windowManager.hyprland.settings.bind = [ "$mod, SPACE, exec, ${pkgs.rofi-wayland}/bin/rofi -show drun"];

    xdg.configFile."rofi/config.rasi".source = pkgs.writeText "rofi-config" ''
      configuration {
      modes: "window,drun,run,ssh";
      font: "Mononoki Nerd Font 18";
      show-icons: true;
      fixed-num-lines: false;
      drun-show-actions: false;
      }
      ${builtins.readFile (config.scheme inputs.base16-rofi)}


      window {
      background-color: @background;
      border: 2;
      padding: 5;
      border-radius: 8;
      border-color: ${config.scheme.withHashtag.base02};
      }

      listview {
      scrollbar: false;
      padding: 4px;
      border-radius: 6px;
      border: 3px solid;
      }

      entry {
      placeholder-color: ${config.scheme.withHashtag.base03};
      }

      element alternate.normal {
      background-color: @normal-background;
      text-color: @normal-foreground;
      }

      element selected.normal {
      background-color: @normal-background;
      text-color: @blue;
      }

    '';
  };
}
