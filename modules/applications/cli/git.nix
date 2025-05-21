{config, pkgs,lib, ... }: {


  options.host.applications.git.enable = lib.mkEnableOption "git";

  config = lib.mkIf config.host.applications.git.enable {

    home.packages = [ 
      pkgs.gh
      pkgs.git
    ];


    programs.git = {

      enable = true;

      userName = "Xenia Herr";

      userEmail = "xeniaherr@gmail.com";

      extraConfig = {
        init = {
          defaultBranch = "main";
        };
      };



    };


    #TODO: Move this in a seperate nix file
    programs.lazygit = {
      enable = true;
    };

  };

}
