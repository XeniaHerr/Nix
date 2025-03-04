{config, pkgs, inputs, ...}:

  with pkgs.lib;
{


  options = {
    host.features.security = {
      enable = mkEnableOption "Enable Security features";



    };
  };
}
