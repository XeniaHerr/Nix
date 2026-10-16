{config, pkgs,lib, ... }: {


  options.host.applications.git.enable = lib.mkEnableOption "git";

  config = lib.mkIf config.host.applications.git.enable {

    home.packages = [ 
      pkgs.gh
      pkgs.git
    ];


    programs.git = {

      enable = true;


      signing = {
        format = "openpgp";
        signByDefault = true;
      };

      settings = {



        user = {
        
      name = "Xenia Herr";

      email = "xeniaherr@gmail.com";
        };

      
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
