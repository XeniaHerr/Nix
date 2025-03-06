{config, pkgs, lib, ...}:
with lib;
{

  options = {
    host.desktop.dunst = mkEnableOption "Dunst notifications";
  };


  config = mkIf config.host.desktop.dunst {

    wayland.windowManager.hyprland.settings.exec-once = [ "${pkgs.dunst}"];

    services.dunst = {
      enable = true;

      settings = {
        global = {
          origin = "top-right";
          follow ="mouse"; # Not what i really want, but there is no real alternative...

          gap_size = 10;
          corner_radius = 5;
          show_indicators = true;
        };

        urgency_normal = {
          background = config.scheme.withHashtag.base02;
          foreground = config.scheme.withHashtag.base05;
        };

        urgency_low = {
          background = config.scheme.withHashtag.base01;
          foreground = config.scheme.withHashtag.base03;
        };

        urgency_critical= {
          background = config.scheme.withHashtag.base08;
          foreground = config.scheme.withHashtag.base06;
        };


      };

    };
  };

}
