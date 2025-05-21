{config, pkgs, lib, inputs, specialArgs, ...}:
let
  inherit (specialArgs) system;
  run-widget = inputs.fabric.packages."${system}".run-widget;
in
  with lib;
{

  imports = [
  ];

  options.host.desktop.wayland.fabric-notifications.enable = mkEnableOption "Fabric notifications";



  config = mkIf (config.host.desktop.wayland.notifications == "fabric") {


    home.packages =  with pkgs; [ 
      python313
      run-widget
    ];

    wayland.windowManager.hyprland.settings.exec-once = [ "${run-widget}/bin/run-widget ${./own.py} ${./ownstyles.css}"];

  };
}
