{configs, pkgs, ... }: {

  programs.kitty = {

    enable = true;


    font = {
      name = "Mononoki Nerd Font";
      size = 14;
      #package = pkgs.nerd-fonts.mononoki;
    };

    themeFile = "Catppuccin-Mocha";


  };

}

