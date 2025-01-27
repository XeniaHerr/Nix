{config, pkgs, lib, windowManager, ...} @ args:

{

      imports = [

        ./i3.nix
      ];
  options = {
    host.desktop.x11.enable = lib.mkEnableOption "X11";
  };


  config = lib.mkIf config.host.desktop.x11.enable
    {


      home.packages = with pkgs; [
      xclip
      ];




  };
}
