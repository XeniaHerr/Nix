{configs, pkgs, ... }: {

  programs.kitty = {

    enable = true;


    font = {
      name = "Mononoki Nerd Font";
      size = 14;
    };

    themeFile = "Catppuccin-Mocha";


  };

}

