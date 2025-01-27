{config, pkgs, catppuccin,lib, ...}:

{

  options = {
    host.applications.btop.enable = lib.mkEnableOption "btop";
  };

  config = lib.mkIf config.host.applications.btop.enable {
  programs.btop = {
    enable = true;
    #catppuccin.enable = true;
    #    catppuccin.flavor = "mocha";

  };

  catppuccin.btop.enable = true;
  catppuccin.btop.flavor = "mocha";


};
}

