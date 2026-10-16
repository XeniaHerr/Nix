{config, pkgs, lib, ...}:
{

  options.host.desktop.wayland.swaylock.enable = lib.mkEnableOption "Swaylock";


  config = lib.mkIf (config.host.desktop.wayland.swaylock.enable) {


    home.packages = [
      pkgs.swaylock];



    programs.swaylock = {
    enable = true;};

  };

}
