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
    ./fabric
    ./caelestia.nix
    ./ax-shell.nix
    ./niri.nix
    ./swww.nix
    ./swaylock.nix
    ./wpaperd.nix


  ];
  options = {
    host.desktop.wayland = {
      enable = lib.mkEnableOption "Wayland";

      launcher = lib.mkOption {
        description = "Which Launcher to use";
        type = lib.types.enum ["rofi" "orkan" ];
        default = "orkan";
      };

      notifications = lib.mkOption {
        description = "What Notifications Service to use";
      type = lib.types.enum ["dunst" "fabric" "caelestia" "ax-shell" ];
        default = "dunst";
      };

    };


  };


  config =   lib.mkIf config.host.desktop.wayland.enable
    {


      home.packages = with pkgs; [
        wl-clipboard
        libnotify
        wlr-randr
      ];

# Helpful command TODO:  wlr-randr --json | jq -r '.[] | select(.description == "Acer Technologies VG270 0x13703D9F (DP-10)" ) | .name'



    };

}
