{configs, pkgs,lib,  ... }:

let 
  mod = "Mod4";

  rosewater = "#f5e0dc";
  flamingo =  "#f2cdcd";
  pink ="#f5c2e7";
  mauve ="#cba6f7";
  red ="#f38ba8";
  maroon ="#eba0ac";
  peach= "#fab387";
  yellow ="#f9e2af";
  green ="#a6e3a1";
  teal= "#94e2d5";
  sky ="#89dceb";
  sapphire ="#74c7ec";
  blue= "#89b4fa";
  lavender ="#b4befe";
  text= "#cdd6f4";
  subtext1 ="#bac2de";
  subtext0 ="#a6adc8";
  overlay2 ="#9399b2";
  overlay1 ="#7f849c";
  overlay0 ="#6c7086";
  surface2 ="#585b70";
  surface1 ="#45475a";
  surface0 ="#313244";
  base ="#1e1e2e";
  mantle ="#181825";
  crust ="#11111b";




  genWorkspacekeyfirst = count: 
  let 
    wslist = lib.genList( x: toString x) count;
    keylist = lib.map (x: "${mod}+" + x) wslist;
  commandlist = lib.map (x: "move to workspace " + x) wslist;
  combined = lib.zipLists keylist commandlist;
  in
    lib.listToAttrs (map ( {fst, snd}: { name = fst; value = snd;}) combined );

 in {
xsession.windowManager.i3 = {
    enable = true;

    extraConfig = ''
    '';
    config = {
      bars = [
        {
          position = "top";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
            fonts = {
          names = [ "Mononoki" ];
          size = 10.0;
        };
        }
      ];
      modifier = mod;
      keybindings = {
      "${mod}+p" = "exec dmenu_run";
     # "${mod}+Shift+p" = "exec ${pkgs.dmenu}/bin/dmenu_run";
        #  "${mod}+Return" = "exec ${pkgs.kitty}/bin/kitty";
        # "${mod}+1" = "workspace 1";
        # "${mod}+2" = "workspace 2";
        #"${mod}+3" = "workspace 3";
        #  "${mod}+4" = "workspace 4";
        # "${mod}+5" = "workspace 5";
        # "${mod}+6" = "workspace 6";
        # "${mod}+7" = "workspace 7";
        # "${mod}+8" = "workspace 8";
        # "${mod}+9" = "workspace 9";


      "${mod}+w" = "kill";

      "${mod}+Shift+1" = "move to workspace 1";
      "${mod}+Shift+2" = "move to workspace 2";
      "${mod}+Shift+3" = "move to workspace 3";
      "${mod}+Shift+4" = "move to workspace 4";
      "${mod}+Shift+5" = "move to workspace 5";
      "${mod}+Shift+6" = "move to workspace 6";
      "${mod}+Shift+7" = "move to workspace 7";
      "${mod}+Shift+8" = "move to workspace 8";
      "${mod}+Shift+9" = "move to workspace 9";

      "${mod}+j" = "focus down";
      "${mod}+h" = "focus left";
      "${mod}+k" = "focus up";
      "${mod}+l" = "focus right";
      "${mod}+Shift+e" = "exit";

      "${mod}+f" = "fullscreen toggle";
      "${mod}+i" = " exec flameshot gui";

      "${mod}+Shift+greater" = "move workspace to output right";
      "${mod}+Shift+less" = "move workspace to output left";
      } // genWorkspacekeyfirst 9;
      fonts = {
        names = [ "Mononoki" ];
        size = 10.0;
      };

      colors = {
        background = base;

        focused = {
          background = base;
          border = lavender;
          text = text;
          #title = "$lavender";
          indicator = rosewater;
          childBorder = lavender;
        };

        unfocused = {
          background = base;
          border =  overlay0;
          text = text;
          indicator = rosewater;
          childBorder = lavender;
        };

        urgent = {
          background = base;
          border =  peach;
          text = peach;
          indicator = overlay0;
          childBorder = lavender;
        };


      };

    };
  };

programs.i3status-rust = {

enable = true;


 bars = {

  default = {
    blocks = [
      {
        block = "battery";
        warning = 25.0;
        interval = 30;
        critical = 15;
        empty_format = " 󰁺 $percentage";
        full_format = " 󰂂 $percentage";
        charging_format = "󰂄 $percentage";
        format = " 󰁿 $percentage";
        not_charging_format = " 󰁿 $percentage";
        full_threshold = 75;
        empty_threshold = 30;
      }
      {
        block = "net";
        interval = 2;
        format = "   $speed_down.eng(prefix:K)";
        format_alt = "   $speed_up.eng(prefix:K)";
      }
      {
        block = "memory";
        format = "   $mem_used_percents ";
        format_alt = "   $swap_used_percents ";
      }
      {
        block = "cpu";
        interval = 1;
        format = "  $utilization ";
        format_alt = "Freq: $frequency";
      }
      {
        block = "sound";
        click = [
        {
        button = "left";
        cmd = "pavucontrol";
        }
        {
          button = "right";
          cmd = "amixer set Master toggle";
        }
        ];
      }
      {
        block = "time";
        format = "  $timestamp.datetime(f:'%a %d/%m %R') ";
        interval = 60;
      }
    ];

    theme = "ctp-mocha";
    icons = "awesome5";
    settings.theme.theme = "ctp-mocha";
  };
};



};

}
