{config, pkgs,lib, ...}: {
# Gnome desktop shell


  options.host.desktop.gnome.enable = lib.mkEnableOption "gnome";


  config  = lib.mkIf (config.host.desktop.gnome.enable) {

#    services.displayManager.gdm.enable = true;
 #   services.desktopManager.gnome.enable = true;

#    environment.systemPackages  = [ pkgs.gnomeExtensions.appindicator];

    home.packages = with pkgs.gnomeExtensions; [
      blur-my-shell
      tweaks-in-system-menu
      pkgs.gnome-tweaks
      workspace-matrix
      dash-to-dock
    ];

#   services.gnome-keyring = {
#  #   enable = true;
# #    components = [ "secrets" "pkcs11"];
#   };



    dconf = {
      enable = true;
      settings = {
        "org/gnome/shell" = {
          enabled-extensions = ["blur-my-shell@aunetx"
                                pkgs.gnomeExtensions.tweaks-in-system-menu.extensionUuid
                                pkgs.gnomeExtensions.system-monitor.extensionUuid
                                pkgs.gnomeExtensions.just-perfection.extensionUuid
                                pkgs.gnomeExtensions.dash-to-dock.extensionUuid
                               ];
        };
        "org/gnome/desktop/interface".show-battery-percentage = true;
        "org/gnome/desktop/input-sources/xkb-options" = {"grp" = "shifts_toggle"; };
      };
    };

  };

}








