{config, pkgs, lib, ...}:

{

  options.host.applications.util.starship.enable = lib.mkEnableOption "starship";


  config = lib.mkIf config.host.applications.util.starship.enable {


    programs.starship = {

      enable = true;
    };

  };
}
