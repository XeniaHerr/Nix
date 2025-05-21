{config, pkgs, lib, ...}:

# List of Applications that i need to develop
{


options = {
  host = {
  features = {

    development.enable = lib.mkEnableOption "development";
  };
  };

};


  config = lib.mkIf config.host.features.development.enable {
  
    host.applications =  with lib; {

      git.enable = mkDefault true;
      nvim.enable = mkDefault true;
      tmux.enable = mkDefault true;
      btop.enable = mkDefault true;
    };


    home.packages = with pkgs; [

      gcc
      rustc
      cloc
      clang-tools
      nodejs
      cmake
      gnumake
    ];
  };
    
  }
