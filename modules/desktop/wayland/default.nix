{config, pkgs, lib, specialArgs, ...} @ args:

let 
  inherit (specialArgs) mywindowManager;
in
  {

  imports = [

    ./hyprland.nix
    ./waybar.nix
    ./rofi.nix
    ./kanshi.nix


  ];
  options = {
    host.desktop.wayland = {
      enable = lib.mkEnableOption "Wayland";

      launcher = lib.mkOption {
        description = "Which Launcher to use";
        type = lib.types.enum ["rofi" "orkan" ];
        default = "orkan";
      };

    };


  };


  config = lib.mkIf config.host.desktop.wayland.enable
    {


      home.packages = with pkgs; [
        wl-clipboard
      ];





    };
}
