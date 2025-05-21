{config, pkgs, lib, ...}:
with lib;
let
  cfg = config.host.applications.elements;
in
{



  options.host.applications.elements.enable = mkEnableOption "Elements matrix client";



  config = mkIf cfg.enable {


    home.packages = [
      pkgs.element-desktop
    ];
  };
}
