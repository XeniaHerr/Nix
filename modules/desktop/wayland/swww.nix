{config, lib, pkgs, ...}:

{

  options.host.desktop.wayland.swww.enable = lib.mkEnableOption "Swww";


  config = lib.mkIf (config.host.desktop.wayland.swww.enable) {

#    programs.swww.enable = true;

    services.swww.enable = true;

  };


}
