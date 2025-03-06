{config, pkgs, lib, specialArgs, ...} @ args:

let 
  inherit (specialArgs) mywindowManager;
in
  {

  imports = [

    ./hyprland.nix
    ./waybar.nix


  ];
  options = {
    host.desktop.wayland.enable = lib.mkEnableOption "Wayland";

  };


  config = lib.mkIf config.host.desktop.wayland.enable
    {


      home.packages = with pkgs; [
        wl-clipboard
      ];





    };
}
