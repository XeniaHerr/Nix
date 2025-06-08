{config, pkgs, lib, ...}:
with lib;
{

  options = {
    host.desktop.dunst = mkEnableOption "Dunst notifications";
  };


  config = mkIf (config.host.desktop.wayland.notifications == "dunst") {

    wayland.windowManager.hyprland.settings.exec-once = [ "${pkgs.dunst}/bin/dunst"];

    home.packages = [
      pkgs.libnotify
    ];

    services.dunst = {
      enable = true;

      settings = {
        global = {
          origin = "top-right";
          follow ="none"; # Not what i really want, but there is no real alternative...
          monitor = "Acer Technologies VG270U P TEHEE00A854F";

          gap_size = 10;
          corner_radius = 5;
          show_indicators = true;

          progress_bar_corner_radius = 2;

          mouse_left_click = "do_action, close_current";
        };

        urgency_normal = {
          background = config.scheme.withHashtag.base01;
          foreground = config.scheme.withHashtag.base05;
          frame_color = config.scheme.withHashtag.base00;
          highlight = config.scheme.withHashtag.base07;
        };

        urgency_low = {
          background = config.scheme.withHashtag.base01;
          foreground = config.scheme.withHashtag.base05;
          frame_color = config.scheme.withHashtag.base00;
          highlight = config.scheme.withHashtag.base17;
        };

        urgency_critical= {
          background = config.scheme.withHashtag.base01;
          foreground = config.scheme.withHashtag.base08;
          frame_color = config.scheme.withHashtag.base12;
          highlight = config.scheme.withHashtag.base17;
        };


      };

    };
  };

}
