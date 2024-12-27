{config,pkgs,  ...}:

{

  services.emacs.enable = true;

  programs.emacs = {
    enable = true;
    #    extraPackages = epkgs: [ epkgs.evil ];
    package = (pkgs.emacsWithPackagesFromUsePackage {

      config = ./emacs.el;

      defaultInitFile = true;


    });
  };
}
