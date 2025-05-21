{config, pkgs, extraSpecialArgs, ...}:

{

  imports = [
    ./shells
    ./applications
    ./desktop
    ./dev
    ./theming
    ./security
    ./mail

  ];


}
