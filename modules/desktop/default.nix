{config, pkgs, lib, ...}:

{
  options = {

    host.desktop.enable = lib.mkEnableOption "display";
    host.desktop.windowManager = lib.mkOption {
      type = lib.types.nonEmptyStr;
      default = "Hyprland";
    };

  };
  imports = [
    ./x11
    ./wayland
    ./utils
  ];
}
