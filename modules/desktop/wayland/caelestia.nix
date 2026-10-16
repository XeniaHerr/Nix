{pkgs, config, lib, ...} @ inputs :
{



  options.host.desktop.wayland.caelestia = {

    enable = lib.mkEnableOption "Caelestia Shell";
  };


  config = lib.mkIf (config.host.desktop.wayland.caelestia.enable && config.host.desktop.windowManager == "Hyprland") {

    host.desktop = {
      waybar = lib.mkForce false;
      #  rofi.enable = lib.mkForce false;
      wayland.notifications = lib.mkForce "caelestia";

      
    };
    programs.caelestia = {
      enable = true;
      systemd = {
        enable = true;
        target = "graphical-session.target";
        environment = [];
        
      };
      settings = {
      };
      cli = {
      enable = true;};
    };
  };

}
