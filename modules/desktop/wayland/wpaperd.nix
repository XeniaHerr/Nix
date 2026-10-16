{config, pkgs,lib, ...}:
{

  options.host.desktop.wayland.wpaperd.enable = lib.mkEnableOption "wpaperd";


  config = lib.mkIf (config.host.desktop.wayland.wpaperd.enable) {

    services.wpaperd = {
      enable = true;
      settings = {

        # any = {
        #   path = "/home/xenia/Pictures/Wallpapers/violet_evergarden.jpg"; };

        "re:TEHEE00A854F" = {
          path = "/home/xenia/Pictures/Wallpapers/violet_evergarden.jpg";
        };


      "re:0x13704B20" = {
        path = "/home/xenia/Pictures/Wallpapers/wallpaperflare.com_wallpaper(3).jpg";
      };

      "re:0x13703D9F" = {
        path = "/home/xenia/Pictures/Wallpapers/wallpaperflare.com_wallpaper(1).jpg";
      };

      "eDP-1"  = {
      path = "/home/xenia/Pictures/Wallpapers/windows_chill.jpg";};
        
      
      };
    };
    
  };
}
