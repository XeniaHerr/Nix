{config, pkgs, lib, inputs, ...}:
with lib;
{

  imports = [
    inputs.fabric.packages."${system}".run-widget
  ];

  options.host.desktop.wayland.fabric-notifications.enable = mkEnableOption "Fabric notifications";



  config = mkIf config.host.desktop.fabric-notifications.enable {


    home.packages =  with pkgs; [ 
      python313
    ];
    
    wayland.windowManager.hyprland.settings.exec-once = [ "${run-widget}/bin/run-widget"];

  };
}
