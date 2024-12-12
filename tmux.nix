{configs, pkgs, ...}:
{

  programs.tmux = {
    enable = true;
    shell = "${pkgs.nushell}/bin/nu";
    clock24 = true;
    keyMode = "vi";
    escapeTime = 10;
    mouse= true;

    customPaneNavigationAndResize = true;
    baseIndex = 1;

    extraConfig = ''
    set -s extended-keys on
    set-option -g xterm-keys on
    set -as terminal-features 'xterm*:extkeys'
    '';

    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = catppuccin;
        extraConfig = ''
        set -g @catppuccin_status_modules_right "application battery date_time"
        set -g @catppuccin_date_time_text "%H:%M"
        set -g @catppuccin_window_default_text "#W"
        set -g @catpuccin_window_current_text "#W"
        '';
      }
      {
        plugin = battery;

      }
      {
        plugin = resurrect;

        extraConfig = ''
        set -g @resurrect-strategy-nvim 'session'
        set -g @ressurect-capture-pane-contents 'on'
        set -g @resurrect-processes '~ssh ~nivm ~man ~btop ~less ~tail ~top'
        resurrect_dir=~/.local/share/tmux/resurrect
        set -g @resurrect-dir $resurrect_dir
        set -g @resurrect-hook-post-save-all "/home/xenia/Sandbox/nushell/tmux_script.nu"
        '';
      }

       #This Plugin needs to be last
       {
         plugin = continuum;
         extraConfig = ''
         set -g @continuum-restore 'on'
         '';
       }

     ];

   };
 }
