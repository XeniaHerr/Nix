{config, pkgs, lib, inputs,  ...}:
with lib;
{

  
  config = {

    home.packages = with pkgs; [
      rofi
    ];

    #    wayland.windowManager.hyprland.settings.bind = [ "$mod, SPACE, exec, ${pkgs.rofi}/bin/rofi -show drun"];

    wayland.windowManager.hyprland.settings.bind = [
      {_args = [
         "SUPER + SPACE"
         (lib.generators.mkLuaInline ("hl.dsp.exec_cmd(\"rofi -show drun\")"))
       ];
      }];
    #font: "Mononoki Nerd Font 18";

    xdg.configFile."rofi/config.rasi".source = pkgs.writeText "rofi-config" ''
      configuration {
      modes: "window,drun,run,ssh";
      terminal: "${pkgs.kitty}/bin/kitty";
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
