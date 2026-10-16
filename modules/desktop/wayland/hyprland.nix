{config, pkgs,lib, inputs, ...}:
let
  center_mon = "desc:Acer Technologies VG270U P TEHEE00A854F";
  left_mon = "desc:Acer Technologies VG270 0x13704B20";
  right_mon = "desc:Acer Technologies VG270 0x13703D9F";

  monitorfordock = (pkgs.writeShellApplication {
        name = "monitorfordock";
        text = builtins.readFile ./monitorscript.sh;
  });

  swaylock-cmd = "${pkgs.swaylock-effects}/bin/swaylock --daemon -S --clock --effect-blur=10x10";
in
{

    config =  lib.mkIf ( config.host.desktop.enable && config.host.desktop.wayland.enable && config.host.desktop.windowManager == "Hyprland"){




    home.packages = with pkgs; [

      hyprshot
      hyprpicker
      jq
      hyprcursor
      rose-pine-hyprcursor
      (pkgs.writeShellScriptBin "toggle-mirror" ''
#!/usr/bin/env bash
STATUS=$(hyprctl monitors -j | jq '.[] | select(.name == "HDMI-A-1") | .mirrorOf')
    if [[ -z "$STATUS"   ]]; then
	hyprctl keyword monitor "HDMI-A-1, preferred, auto, 1"
    else
	hyprctl keyword monitor "HDMI-A-1, preferred, auto, 1, mirror, eDP-1"
    fi

'')

      (pkgs.writeShellScriptBin "focusworkspacewith" ''
        #!/usr/bin/env bash
        hyprctl dispatch focusworkspaceoncurrentmonitor $(hyprctl clients -j | jq '.[] | select(.class == "$1") | .workspace.id')
      '')

    ];

    wayland.windowManager.hyprland = {

      enable = true;
      configType = "lua";
      settings = {



        mod = {
        _var  = "SUPER";};



        bind = let

          movements = { keymaps ? { "l" = "b"; "u" = "p"; "d" = "n"; "r" = "f";}, moveprefix ? "SHIFT", target ? "direction"}: let
            dirs = builtins.attrNames keymaps;
            pluspadprefix = if moveprefix != "" then "+ " + moveprefix else "";
          in 
            lib.flatten (map (direction: [{ _args = [ ("SUPER + "  + keymaps.${direction} )
                                                      (lib.generators.mkLuaInline ("hl.dsp.focus({${target} = \"${direction}\"})"))];
                                          } ] ++
                                            lib.optional (moveprefix != "")
                                              {_args = [ ("SUPER " + pluspadprefix + " + " + keymaps.${direction})
(lib.generators.mkLuaInline ("hl.dsp.window.move({${target} = \"${direction}\"})"))];
}
) dirs);


          exec = key: command: {
            _args = [
              key
              (lib.generators.mkLuaInline ("hl.dsp.exec_cmd(\"" + command + "\")"))
            ];
          };

          workspaces  = n: let
          in lib.flatten (map (ws: [
            {_args = [("SUPER +  ${toString ws}")
                      (lib.generators.mkLuaInline ("hl.dsp.focus({workspace = \"${toString (ws)}\", on_current_monitor = true })"))
                     ]; }
            {_args = [("SUPER + SHIFT + ${toString ws}" )
                      (lib.generators.mkLuaInline ("hl.dsp.window.move({workspace = \"${toString (ws)}\", follow = false})"))];}

          ]
          ) (builtins.genList (x: x+1 ) n));
          in [
            (exec "SUPER + RETURN" "kitty")
            (exec "SUPER + SHIFT + e" "emacsclient -c")

            { _args = [
                "SUPER + SHIFT + Q"
                (lib.generators.mkLuaInline ("hl.dsp.exit()"))
              ];
            }

            { _args = [
                "SUPER + w"
                (lib.generators.mkLuaInline ("hl.dsp.window.close()"))
              ];
            }

                        { _args = [
                "SUPER + m"
                (lib.generators.mkLuaInline ("hl.dsp.window.fullscreen({action =\"toggle\"})"))
              ];
            }
                        { _args = [
                "SUPER + t"
                (lib.generators.mkLuaInline ("hl.dsp.window.float({action =\"toggle\"})"))
              ];
            }

                        { _args = [
                "SUPER + tab"
                (lib.generators.mkLuaInline ("hl.dsp.focus({workspace = \"previous\"})"))
              ];
            }
{ _args = [
                "SUPER + l"
                (lib.generators.mkLuaInline ("hl.dsp.submap(\"layoutselection\")"))
              ];
}

            (exec "SUPER + SHIFT + ALT + DELETE" "loginctl lock-session")
            (exec "XF86MonBrightnessUp" "brightnessctl s +5%")
            (exec "XF86MonBrightnessDown" "brightnessctl s 5%-")


            {_args = [
               "SUPER + mouse:272"
               (lib.generators.mkLuaInline ("hl.dsp.window.drag( {mouse = true})"))
            ];}
            {_args = [
               "SUPER + mouse:273"
               (lib.generators.mkLuaInline "hl.dsp.window.resize()), ({mouse = true}")
            ];}
                        

          ] ++ movements { keymaps = {"l" = "bracketleft"; "r" = "bracketright";}; target = "monitor";}
          ++ movements {}
          ++ workspaces 9;



          
#           (lib.generators.mkLuaInline "\"layoutselection\", \"reset\", function()
# hl.dsp.bind(\"m\", function() hl.config({layout = \"monocle\"}) end)
# hl.dsp.bind(\"d\", function() hl.config({layout = \"dwindlw\"}) end)
# end
# ")



        workspace_rule = let
          makedefaultnames = {names}:
            lib.flatten (map (number: [
              {
                workspace = "${toString number}";

                default_name = builtins.elemAt names (number -1);
               }]
            ) (builtins.genList (x: x +1) (builtins.length names)));
          in
          [
          ] ++ makedefaultnames { names = ["desk" "browser" "editor" "games"];};

        
        # bind = [
        #   "$mod, Return, exec, kitty"
        #   "$mod, x, exec, firefox"
        #   "$mod, d, exec, Orkan run"
        #   "$mod SHIFT, E, exec, emacsclient -c"
        #   "$mod SHIFT, Q, exit"
        #   #        "$mod, F, fullscreen, 0"
        #   "$mod, w, killactive"
        #   "$mod, t, togglefloating, active"
        #   "$mod, m, pin, active"

        #   "$mod SHIFT, Period, movewindow, mon:+1 silent"
        #   "$mod SHIFT, Comma, movewindow, mon:-1 silent"
        #   "$mod, Tab, focusworkspaceoncurrentmonitor, previous"
        #   "$mod, Bracketright, focusmonitor, r"
        #   "$mod, Bracketleft, focusmonitor, l"


        #   "$mod SHIFT, u, layoutmsg, swapcol l"
        #   "$mod SHIFT, d, layoutmsg, swapcol r"
        #   "$mod, period, layoutmsg, togglefit"
        #   "$mod SHIFT, c, layoutmsg, promote"
        #   "$mod ALT SHIFT, Delete, exec, ${pkgs.hyprlock}/bin/hyprlock"
        #   "$mod, Print, exec ,${pkgs.hyprshot}/bin/hyprshot -m region -o ~/Pictures/"


        #   "$mod, s, togglespecialworkspace"
        #   "$mod SHIFT, s, movetoworkspace, special"

        #   #"$mod SHIFT, r, exec, eww update activeworkspacename=\"$(hyprctl activeworkspace -j | ${pkgs.jq} -r '.name')\"; eww open renamer"

        # ] ++ (
        #   builtins.concatLists (builtins.genList (
        #     x: let
        #       ws = let
        #         c = (x +1 ) / 10;
        #       in
        #         builtins.toString (x + 1 - (c * 10));
        #     in [
        #       "$mod, ${ws}, focusworkspaceoncurrentmonitor, ${toString (x +1)}"
        #       "$mod SHIFT, ${ws}, movetoworkspacesilent, ${toString (x +1)}"
        #     ]
        #   ) 
        #     10)
        # );


        # bindm = [
        #   "$mod, mouse:272, movewindow"
        #   "$mod, mouse:273, resizewindow"
        # ];

        # debug.disable_logs = true;

        # exec-once = [ #"${pkgs.eww}/bin/eww open example" 
        #   "${pkgs.eww}/bin/eww open activatelinux"
        #   "${pkgs.networkmanagerapplet}/bin/nm-applet"
        #   #  "${monitorfordock}/bin/monitorfordock"
        # ];
        # #++ lib.optionals config.host.desktop.dunst [
        # #    "${pkgs.dunst}"
        # #  ];

        # on = [{
        #   _args =  [
        #     "hyprland.start"
        #     (lib.generators.mkLuaInline "function ()\n hl.exec_cmd(\"${pkgs.eww}/bin/eww open example\")\nend")
        #   ];
        # }];




        monitor = [

          {
            output = left_mon;
            mode = "preferred";
            position = "1200x0";
            scale = 1;
            transform = 1;
          }

          {
            output = center_mon;
            mode = "preferred";
            position = "2280x0";
            scale = 1;
          }
          { output = right_mon;
            mode = "preferred";
            position = "4840x0";
            scale = 1;
          }

        ];

        # input = {
        #   kb_layout = "us,de";

        #   kb_options = "grp:shifts_toggle";

        #   touchpad = {

        #     tap-to-click = false;
        #     natural_scroll = true;
        #   };
        # };

        gesture = [

          { fingers = 3;
            direction = "horizontal";
          action = "workspace";}

        ];

        # Gestures = {
        #   workspace_swipe = true;
        #   workspace_swipe_fingers = 3;

        # };
        # gesture = [
        #   "3, horizontal, workspace"];

        # env = [
        #   "HYPRCURSOR_THEME,rose-pine-hyprcursor"
        #   "AQ_DRM_DEVICES,/dev/dri/card1"
        # ];


        # device = {

        #   key = "Enter, bincode:36";
        #};

        config = {
        general = {
          border_size = 2;
          gaps_in = 5;
          gaps_out = 5;
          layout = "dwindle";
        };

        debug.disable_logs = false;

        xwayland = {
          force_zero_scaling = true;
        };
        input = {
          kb_layout = "us,de";
          kb_options = "grp:shifts_toggle";

          touchpad = {
            disable_while_typing = true;
            natural_scroll = true;
            tap_to_click = false;

          };


        };
        };


        window_rule = [

          {name = "Calculator";
           match = { class = "org.gnome.Calculator";
               };
           float = true;}

          # {name ="Firefox extensions";
          #  match = {
          #    initial_class = "firefox";
          #    title = "Extension: (Bitwarden Password Manager) - Bitwarden — Mozilla Firefox";
          #  };
          #    float = true;
          # }
          

        ];

# TODO: Redo this stuff
        # windowrule = [
        #   "idleinhibit fullscreen, class:.*"
        #   "float on, class:org.gnome.Calculator"
        #   "float on, title:Extension .* Mozilla Firefox"
        # ];

        # windowrule = [
          
        # ];

        # layerrule = [
        #   "blur, rofi"
        #   "animation slide top, rofi"
        #   "animation slide right, dunst"
        # ];



      #   decoration = {
      #     rounding = 10;


      #     active_opacity = 1.0;

      #     inactive_opacity = 1.0;

      #     blur = {
      #       enabled = true;
      #       size = 8;
      #       passes = 1;
      #       vibrancy = 0.1696;
      #     };

      #     shadow = {
      #       enabled = true;
      #       range = 4;
      #       render_power = 3;
      #       #col.shadow = "rgba(1a1a1aee)";

      #     };


      #   };

      #   xwayland = {

      #     force_zero_scaling = true;
      #   };

      #   animations = {

      #     enabled = true;

      #     bezier = [
      #       "linear, 0,0,1,1"
      #       "overshot, 0.05, 0.9, 0.1, 1.1"
      #       "easeInOutQuart, 0.76, 0, 0.24, 1"
      #       "easeInOutBack, 0.68, -0.6, 0.32, 1.6"
      #       "easeOutQubic, 0.33, 1, 0.68, 1"
      #     ];

      #     animation = [
      #       "windowsIn, 1, 2, easeInOutQuart, slide"
      #       "windowsMove, 1, 2, easeOutQubic, slide"
      #       "windowsOut, 1, 2, easeInOutQuart, popin"
      #       "workspacesIn, 1, 3, easeOutQubic, slide"
      #       "workspaces, 1,3, easeOutQubic, slide"
      #       "layersOut,1,2, linear, slide" 
      #     ];


      #   };

      #   plugin = {
      #     hyprexpo = {
      #       columns = 3;
      #       gap_size = 5;
      #       workspace_method = "center current";
      #      # enable_gesture = true;
      #     #  gesture_fingers = 3;
      #     #  gesture_positive = true;
      #     };


      #     hyprscrolling = {

      #       fullscreen_on_one_column = true;
            
      #     };
      #     overview = {
      #       autoScroll = true;

      #       exitonSwitch = true;

      #     };
      #   };
        

      };

      extraConfig= ''



hl.define_submap("layoutselection", "reset", function()
hl.bind("f", function() hl.config({general = {layout = "monocle"}}) end)
hl.bind("d", function() hl.config({general = {layout = "dwindle"}}) end)
hl.bind("m", function() hl.config({general = {layout = "master"}}) end)
hl.bind("s", function() hl.config({general = {layout = "scrolling"}}) end)
end
)

'';


      plugins = with pkgs.hyprlandPlugins; [
        #  hyprexpo
        #hyprspace
        #  inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
        #hyprscrolling
      ];
    };
    services.swayidle =
    let
            black-lock = "${pkgs.swaylock-effects}/bin/swaylock --daemon ";
in
    {
      enable = false;
#      lock = swaylock-cmd;
      timeouts = [
        { timeout = 300;
           command = swaylock-cmd;
        }
        {timeout = 600;
         command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
         resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
        }
      ];

      events = [

         {

          event = "before-sleep";
          command = black-lock;
         }

         {
           event = "lock";
           command = swaylock-cmd;
           }
      ];
#           "before-sleep" =   "swaylock -f -c 00000000";

        

    };



    programs.hyprlock = {
      enable = true;

      settings = {

        general = {
          #      disable_loading_bar = false;

          hide_cursor = false;
        };

        auth = {
          # "fingerprint:enabled" = true;
        };

        background = {
          color = "rgba(0,0,0,1)";
        };

        background = {
          monitor = "";
          path = "~/Pictures/Wallpapers/wallpaperflare.com_wallpaper(5).jpg";
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


        input-field = {
          monitor = "";
          size = "20%, 5%";
          outline_thickness = 2;
          inner_color = "rgba(0,0,0,0)";

          outer_color = "rgba(33ccffee)";

          placeholder_text = "<i>Input Passwd...</i>";
          fade_on_empty = false;
          halign = "center";
          valign = "center";
          position = "0, 0";
        };
      };
    };

    services.hypridle = {
      enable = true;

      settings = {

        general = {

          lock_cmd = "pidof hyprlock || hyprlock";

          before_sleep_cmd = "loginctl lock-session";

          after_sleep_cmd = "hyprctl dispatch  'hl.dsp.dpms({action = \"enable\"})'";


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

    # services.hyprpaper = {

    #   enable = if (config.host.desktop.windowManager == "Hyprland") then true else false;

    #   settings = {

    #     preload = [
    #       "~/Pictures/Wallpapers/wallpaperflare.com_wallpaper(1).jpg"
    #       "~/Pictures/Wallpapers/wallpaperflare.com_wallpaper(3).jpg"
    #       "~/Pictures/Wallpapers/violet_evergarden.jpg"
    #     ];

    #     wallpaper = [
    #       "eDP-1, ~/Pictures/Wallpapers/wallpaperflare.com_wallpaper(1).jpg"
    #       "${left_mon}, ~/Pictures/Wallpapers/wallpaperflare.com_wallpaper(3).jpg"
    #       "${center_mon}, ~/Pictures/Wallpapers/violet_evergarden.jpg"
    #     ];
    #   };

    # }    ;

  };

}











