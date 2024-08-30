{configs, pkgs, ...}:
{

  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    clock24 = true;
    keyMode = "vi";
    escapeTime = 10;
    mouse= true;

    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = catppuccin;
        extraConfig = ''
    set -g @catppuccin_status_modules_right "application battery date_time"
    set -g @catppuccin_date_time_text "%H:%M"

        '';
      }
      {
        plugin = battery;

      }
      {
        plugin = resurrect;
       }

       #This Plugin needs to be last
#       {
 #        plugin = continuum;
 #    }
      
    ];

  };
}
