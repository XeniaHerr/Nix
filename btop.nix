{configs, pkgs, catppuccin, ...}:
{
  programs.btop = {
    enable = true;
    #catppuccin.enable = true;
    #    catppuccin.flavor = "mocha";

  };

  catppuccin.btop.enable = true;
  catppuccin.btop.flavor = "mocha";


}

