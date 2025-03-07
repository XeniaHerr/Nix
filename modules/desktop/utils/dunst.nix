{config, pkgs, lib, ...}:
with lib;
{

  options = {
    host.desktop.dunst = mkEnableOption "Dunst notifications";
  };


  config = mkIf config.host.desktop.dunst {

    wayland.windowManager.hyprland.settings.exec-once = [ "${pkgs.dunst}/bin/dunst"];

    home.packages = [
      pkgs.libnotify
    ];

    services.dunst = {
      enable = true;

      settings = {
        global = {
          origin = "top-right";
          follow ="mouse"; # Not what i really want, but there is no real alternative...

          gap_size = 10;
          corner_radius = 5;
          show_indicators = true;

          progress_bar_corner_radius = 2;

          mouse_left_click = "do_action, close_current";
        };

        urgency_normal = {
          background = config.scheme.withHashtag.base01;
          foreground = config.scheme.withHashtag.base06;
          frame_color = config.scheme.withHashtag.base01;
          highlight = config.scheme.withHashtag.base07;
        };

        urgency_low = {
          background = config.scheme.withHashtag.base01;
          foreground = config.scheme.withHashtag.base0A;
          frame_color = config.scheme.withHashtag.base01;
          highlight = config.scheme.withHashtag.base17;
        };

        urgency_critical= {
          background = config.scheme.withHashtag.base01;
          foreground = config.scheme.withHashtag.base08;
          frame_color = config.scheme.withHashtag.base01;
          highlight = config.scheme.withHashtag.base17;
        };


      };

    };
  };

}
