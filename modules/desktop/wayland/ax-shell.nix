{pkgs, lib, config, inputs,system, ...}:
{

    # imports = [
    # inputs.ax-shell.homeManagerModules.default];

  
  options.host.desktop.wayland.ax-shell.enable = lib.mkEnableOption "Ax-Shell for Hyprland";

  # config = lib.mkIf (config.host.desktop.wayland.ax-shell.enable) {

  #   host.desktop.wayland.caelestia.enable = lib.mkForce false;
  #   home.packages = with pkgs;  [
  #     #      inputs.ax-shell.packages."x86_64-linux".ax-send
  #     #     uwsm
  #     # pkgs.ax-shell
  #     # pkgs.ax-send
  #   ];

  #   host.desktop.waybar = lib.mkForce false;
  #   host.desktop.wayland.notifications = "ax-shell";
  #   wayland.windowManager.hyprland = {

  #      settings.exec-once =  config.programs.ax-shell.hyprlandExecOnce;
  #   };
  #   programs.ax-shell = {
  #     enable = true;
  #     package = inputs.ax-shell.packages."x86_64-linux".ax-shell;
  #     settings.selected_monitors = ["eDP-1" "desc:Acer Technologies VG270U P TEHEE00A854F" ];


  # };
  # };
  

}
