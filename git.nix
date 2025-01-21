{config, pkgs, ... }: {



  home.packages = [ 
    pkgs.gh
    pkgs.git
  ];


  programs.git = {

    enable = true;

    userName = "Xenia Herr";

    userEmail = "xeniaherr@gmail.com";

  };


}
