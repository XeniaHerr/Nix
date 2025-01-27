{config, pkgs, lib, ...} @ args:

{

      imports = [

        ./hyprland.nix

        
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
