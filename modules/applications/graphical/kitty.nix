{ config, pkgs,lib, inputs, ... }: 
with lib;
{


  options = {
    host.applications.kitty.enable = pkgs.lib.mkEnableOption "kitty";
  };

config = lib.mkIf config.host.applications.kitty.enable {

  programs.kitty = {

    enable = true;


    font = {
      name = "Mononoki Nerd Font";
      size = 14;
    };

      themeFile = "Catppuccin-Mocha";

      extraConfig = config.scheme inputs.base16-kitty;
/*
      settings = {

        #base00 = "#${config.colorScheme.palette.base00}";
        # base01 = "#${config.colorScheme.palette.base01}";
        # base02 = "#${config.colorScheme.palette.base02}";
        # base03 = "#${config.colorScheme.palette.base03}";
        base04 = "#${config.colorScheme.palette.base04}";
        base05 = "#${config.colorScheme.palette.base05}";
        base06 = "#${config.colorScheme.palette.base06}";
        base07 = "#${config.colorScheme.palette.base07}";
        base08 = "#${config.colorScheme.palette.base08}";
        base09 = "#${config.colorScheme.palette.base09}";
        base10 = "#${config.colorScheme.palette.base0A}";
        base11 = "#${config.colorScheme.palette.base0B}";
        base12 = "#${config.colorScheme.palette.base0C}";
        base13 = "#${config.colorScheme.palette.base0D}";
        base14 = "#${config.colorScheme.palette.base0E}";
        base15 = "#${config.colorScheme.palette.base0F}";

        foreground = "#${config.colorScheme.palette.base05}";
        background = "#${config.colorScheme.palette.base00}";
        selection_foreground = "#${config.colorScheme.palette.base00}";
        selection_background = "${config.colorScheme.palette.base06}";
        url_color = "${config.colorScheme.palette.base06}";
        cursor = "${config.colorScheme.palette.base06}";
        cursor_text_color = "#${config.colorScheme.palette.base00}";
        active_border_color = "#${config.colorScheme.palette.base07}";
      };
      */

  };

  };

}

