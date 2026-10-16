{config, pkgs, lib, ...}:

  let
  center_mon = "Acer Technologies VG270U P TEHEE00A854F";
  left_mon = "Acer Technologies VG270 0x13704B20";
  right_mon = "Acer Technologies VG270 0x13703D9F";
in
  {

  config = {

  services.kanshi = {
    enable  = false; #  if config.host.desktop.windowManager == "niri" then false else true;
      systemdTarget =  if config.host.desktop.windowManager == "niri" then "niri.service" else "hyprland-session.target";

    settings = [  

{

        profile.name = "dock";

        profile.outputs = [

          {
            scale = 1.0;
            status = "enable";
            criteria = left_mon;
            position = "0,0";
            transform = "90";
          }
          {
            scale = 1.0;
            status = "enable";
            criteria = center_mon;
            position = "1080,0";
          }
          {
            scale = 1.0;
            status = "enable";
            criteria = right_mon;
            position = "3640,0";
          }
          {
            scale = 1.0;
            status = "enable";
            criteria = "eDP-1";
          }
        ];
      }
        {
      profile.name = "default";

      profile.outputs = [
        {
          scale = 1.0;
          status = "enable";
          criteria = "eDP-1";
        }

      ];
    }


        {
      profile.name = "one_random_monitor";

      profile.outputs = [
        {
          scale = 1.0;
          status = "enable";
          criteria = "Lenovo Group Limited 0x403A";
        }

       # Enable all other displays
        { scale = 1.0;
          status = "enable";
          criteria = "*";
        }
      ];
    }


        
      
    ];
  };

  };
  }
