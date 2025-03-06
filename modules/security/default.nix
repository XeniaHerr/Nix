{config,lib,specialArgs,...}:

with lib;
let
  inherit (specialArgs) yubikey_id;
in
  {


  options = {
    host.features.security = {
      enable = mkEnableOption "Enable Security features";



    };
  };


  config = mkIf config.host.features.security.enable {

  };
}
