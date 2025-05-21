{config, pkgs, ...}:

{

  imports = [
  ./kitty.nix
    ./orkanmodule.nix
    ./zathura.nix
    ./elements.nix
  ];


  home.packages = with pkgs; [
    gnome-calculator
    nautilus
  ];
}
