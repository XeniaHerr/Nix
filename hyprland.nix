{config, pkgs, ...}:
{


  home.packages = with pkgs; [

    hyprshot
    hyprpicker

  ];

  wayland.windowManager.hyprland = {

    enable = true;
    settings = {
      "$mod" = "Super";
      bind = [
        "$mod, Return, exec, kitty"
        "$mod, x, exec, firefox"
        "$mod, d, exec, Orkan run"
        "$mod SHIFT, Q, exit"
        "$mod, F, fullscreen, 0"
        "$mod, w, killactive"
        "$mod, t, togglefloating, active"
        "$mod, p, pin, active"
        "$mod SHIFT, Period, movewindow, mon:+1 silent"
        "$mod SHIFT, Comma, movewindow, mon:-1 silent"
        "$mod, Tab, focusworkspaceoncurrentmonitor, previous"
        "$mod, Bracketright, focusmonitor, r"
        "$mod, Bracketleft, focusmonitor, l"

        "$mod, h, movefocus, l"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"
        "$mod, l, movefocus, r"

        "$mod SHIFT, h, movewindow, l"
        "$mod SHIFT, j, movewindow, d"
        "$mod SHIFT, k, movewindow, u"
        "$mod SHIFT, l, movewindow, r"

        "$mod ALT SHIFT, Delete, exec, ${pkgs.hyprlock}/bin/hyprlock"
        "$mod, Print, exec ,${pkgs.hyprshot}/bin/hyprshot -m region -o ~/Pictures/"

      ] ++ (
        builtins.concatLists (builtins.genList (
          x: let
            ws = let
              c = (x +1 ) / 10;
            in
            builtins.toString (x + 1 - (c * 10));
          in [
            "$mod, ${ws}, focusworkspaceoncurrentmonitor, ${toString (x +1)}"
            "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x +1)}"
          ]
          ) 
          10)
          );


          bindm = [
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
          ];

      debug.disable_logs = false;

          exec-once = [ "eww open example" "eww open activatelinux"];

          monitor = [
            "desc:Acer Technologies VG270 0x13704B20, preferred, 1200x0, 1, transform, 1"
            "desc:Acer Technologies VG270U P TEHEE00A854F, preferred, 2280x0, 1"
            "desc:Acer Technologies VG270 0x13703D9F, preferred, 4840x0, 1"
            "desc:Optoma Corporation Optoma 1080P, preferred, auto, 1, mirror, eDP-1"
            "desc:BOE 0x0B66, 1920x1200@60, auto, 1"
          ];

          input = {
            kb_layout = "us,de";

            kb_options = "grp:shifts_toggle";

            touchpad = {

              tap-to-click = false;
            };
          };

         # device = {

         #   key = "Enter, bincode:36";
          #};


          general = {
            border_size = 2;
            gaps_in = 5;
            gaps_out = 20;
            layout = "dwindle";
          };


      windowrulev2 = [
        "idleinhibit fullscreen, class:.*"
      ];


          decoration = {
            rounding = 10;


            active_opacity = 1.0;

            inactive_opacity = 1.0;

            blur = {
              enabled = true;
              size = 3;
              passes = 1;
              vibrancy = 0.1696;
            };

            shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          #col.shadow = "rgba(1a1a1aee)";

            };


          };

          xwayland = {

            force_zero_scaling = true;
          };

          animations = {

            enabled = true;

            bezier = [
              "linear, 0,0,1,1"
              "overshot, 0.05, 0.9, 0.1, 1.1"
              "easeInOutQuart, 0.76, 0, 0.24, 1"
              "easeInOutBack, 0.68, -0.6, 0.32, 1.6"
              "easeOutQubic, 0.33, 1, 0.68, 1)"
            ];

            animation = [
              "windowsIn, 1, 3, easeInOutQuart, slide"
              "windowsMove, 1, 3, easeOutQubic, slide"
              "windowsOut, 1, 3, easeInOutQuart, popin"
              "workspacesIn, 1, 3, easeOutQubic, slide"
              "workspaces, 1,3, easeOutQubic, slidevert"
            ];


          };
       
        };
      };



  programs.hyprlock = {
    enable = true;

    settings = {

      general = {
      disable_loading_bar = false;

      hide_cursor = false;
      };

      auth = {
        # "fingerprint:enabled" = true;
      };

      background = {
        color = "rgba(0,0,0,1)";
      };


      label = {
        monitor = "";
        text = "Hello $USER";
        color = "rgba(1.0,1.0,1.0,1.0)";
      "font_size" = 25;
        font_family = "Mononoki Nerd Font";

        halign = "center";
        valign = "center";
        position = "0, 80";
      };
    };
  };

  services.hypridle = {
    enable = true;

    settings = {

    general = {

      lock_cmd = "pidof hyprlock || hyprlock";

      before_sleep_cmd = "loginctl lock-session";

      after_sleep_cmd = "hyprctl dispatch dpms on";


    };

      listener = [

        {
          timeout = 300;
            on-timeout = "loginctl lock-session";
        }

        {
          timeout = 1500;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };



    }
