{config, pkgs, lib, inputs,system,  ...}:
let #this method is taken from sodiboo
            binds =
              {
                suffixes,
                prefixes,
                substitutions ? { },
              }:
              let
                replacer = builtins.replaceStrings (builtins.attrNames substitutions) (builtins.attrValues substitutions);
                format =
                  prefix: suffix:
                  let
                    actual-suffix =
                      if builtins.isList suffix.action then
                        {
                          action = builtins.head suffix.action;
                          args = builtins.tail suffix.action;
                        }
                      else
                        {
                          inherit (suffix) action;
                          args = [ ];
                        };

                    action = replacer "${prefix.action}-${actual-suffix.action}";
                  in
                  {
                    name = "${prefix.key}+${suffix.key}";
                    value.action.${action} = actual-suffix.args;
                  };
                pairs =
                  attrs: fn:
                  builtins.concatMap (
                    key:
                    fn {
                      inherit key;
                      action = attrs.${key};
                    }
                  ) (builtins.attrNames attrs);
              in
                builtins.listToAttrs (pairs prefixes (prefix: pairs suffixes (suffix: [ (format prefix suffix) ])));

            swaylock-cmd = "${pkgs.swaylock-effects}/bin/swaylock --daemon -S --clock --effect-blur=10x10";
            black-lock = "${pkgs.swaylock-effects}/bin/swaylock --daemon ";
            inherit (inputs) my-bar;
in
{

  options.host.desktop.niri.enable = lib.mkEnableOption "Niri Window Manager";


  config = lib.mkIf (config.host.desktop.niri.enable) {

    home.packages = [
      pkgs.xwayland-satellite
#      pkgs.swaylock-effects
    ];


    services.swayidle = {
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


#    wayland.windowManager.niri.enable = true;
    programs.niri.enable = false;
    programs.niri.package = pkgs.niri;
    programs.niri.settings = {
      prefer-no-csd = true;
      input = {
        keyboard.xkb.layout = "us,de";
        keyboard.xkb.options = "grp:shifts_toggle";
        touchpad.tap = false;

        focus-follows-mouse = {enable = true;
                              max-scroll-amount = "0%";};
      };
      
      outputs = {
        "center-mon" = {
          name = "Acer Technologies VG270U P TEHEE00A854F";
          position = {
            x = 1080;
            y = 0;};
          focus-at-startup = true;
        };
        "left-mon" = {
          name = "Acer Technologies VG270 0x13704B20";
          position = {
            x = 0; y = 0;};
          transform.rotation = 90;
        };

        "right-mon" = {
          name = "Acer Technologies VG270 0x13703D9F";
          position = {
            x = 3640;
            y = 0;
          };
        };
        "eDP-1" = {
          name = "eDP-1";

          scale = 1.0;
          mode = {
            width = 1920;
            height = 1200;
          };
        };
      };

      workspaces = {
        "chats" = {
        name =   "Communication";
        };};

      layout = {
        preset-column-widths = [
          { proportion = 0.33333; } 
          { proportion = 0.5; } 
          { proportion = 0.66667; }];


            # struts = {
        # top = 20;};

        shadow = {
          enable = true;
          softness = 30;
          spread = 5;
          draw-behind-window = true;
          color = "#00000070";
            
          
        };


      };

      hotkey-overlay = {
        skip-at-startup = true;
        hide-not-bound = true;
      };

      layer-rules = [
        {
          matches = [{ namespace = "^rofi.*";}];
          opacity = 0.95;
          block-out-from = "screencast";}
      ];


      window-rules = [
        
        { clip-to-geometry = true;
          geometry-corner-radius = let r = 6.0; in
                                          {
                                            top-left = r;
                                            top-right = r;
                                            bottom-right = r;
                                            bottom-left = r;
                                 };
        }
        {
          matches = [
            {app-id = "^signal.*";}
            { app-id = "org.telegram.desktop";}
            { app-id = "^Element.*";}
            { app-id = "^Mattermost.*";}
            {app-id = "thunderbird";}
            {app-id = "^whatsapp.*";}];
          block-out-from = "screencast";
          open-on-workspace = "Communication";
        }

      ];
      
      spawn-at-startup = let
        mybar = my-bar.packages."${system}".my_quickshell;
        in 
        [
        {argv = ["${pkgs.eww}/bin/eww open activatelinux"] ;        }
        {argv = ["${pkgs.networkmanagerapplet}/bin/nm-applet"];}
        {argv = ["${mybar}/bin/myshell"];}
        {argv = ["${pkgs.swayidle}/bin/swayidle -w timeout 300 '${swaylock-cmd}'  timeout 600 'niri msg action power-off-monitors'  resume 'niri msg action power-on-monitors'  before-sleep 'swaylock -f -c 000000'
"];}
      ];

      gestures.hot-corners.enable = false;

      binds = with config.lib.niri.actions; let sh = spawn "sh" "-c"; in  lib.attrsets.mergeAttrsList [{
        "Mod+Shift+q".action = quit;
        "Mod+Return".action = spawn "kitty";
        "Mod+Tab".action = focus-workspace-previous;
        "Mod+M".action = maximize-column;
        "Mod+T".action = toggle-column-tabbed-display;
        "Mod+Shift+Tab".action = toggle-overview;
        "Mod+W".action = close-window;
        "Mod+Space".action = sh "${pkgs.rofi}/bin/rofi -show drun";
        "Mod+C".action = switch-preset-column-width;
        "Mod+Shift+C".action = expand-column-to-available-width;


        "Mod+Shift+Ctrl+Delete".action = sh swaylock-cmd;

        "Mod+Shift+Up".action = fullscreen-window;

        "Mod+Shift+E".action = sh "emacsclient -c";

        "Mod+Print".action.screenshot = [ ];
        
      } 

                                                                        (binds {
                    suffixes = builtins.listToAttrs (
                      map (n:           let
            ws = let
              c = (n +1 ) / 10;
            in
             n + 1 - (c * 10);
in
                        {
                        name = toString ws;
                        value = [
                          "workspace"
                          (n +1) 
                        ]; # workspace 1 is empty; workspace 2 is the logical first.
                      }) (lib.range 0 9)
                    );
                    prefixes."Mod" = "focus";
                    prefixes."Mod+Shift" = "move-window-to";

                                                                        })
                  (binds {
                    suffixes."b" = "column-left";
                    suffixes."n" = "window-down";
                    suffixes."p" = "window-up";
                    suffixes."f" = "column-right";
                    prefixes."Mod" = "focus";
                    prefixes."Mod+Shift" = "move";
#                    prefixes."Mod+Ctrl" = "focus-monitor";
                    prefixes."Mod+Ctrl" = "move-window-to-monitor";
                    substitutions."monitor-column" = "monitor";
                    substitutions."monitor-window" = "monitor";
                  }) {
                    "Mod+Shift+Comma".action = consume-or-expel-window-left;
                    "Mod+Shift+Period".action = consume-or-expel-window-right;
                  }
                                                                                                       (binds {
                                                                                                         suffixes."bracketright" = "right";
                                                                                                         suffixes."bracketleft" = "left";
                                                                                                         prefixes."Mod" = "focus-monitor";
                                                                                                         prefixes."Mod+Shift+Ctrl" = "move-workspace-to-monitor";
                                                                                                         prefixes."Mod+Shift" = "move-window-to-monitor";
                                                                                                           
                                                                                                       })
                                                                        ];
                                                                        
                                                                        
       
      };
  };
}











