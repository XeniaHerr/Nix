{ config, pkgs,lib, ... }: {


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


  };

  };

}

