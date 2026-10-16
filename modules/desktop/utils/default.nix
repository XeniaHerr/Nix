{pkgs, ...}:

{
  imports = [
    ./dunst.nix
  ];


  home.packages = with pkgs; [
    mattermost-desktop
    spotify
    spotatui
    discord
  ];
}
