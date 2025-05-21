{config,pkgs, lib,...}:

with lib;
{

  options.host.applications.cli.emacs.enable = mkEnableOption "Emacs";

  config = mkIf config.host.applications.cli.emacs.enable {


    home.packages = [
      pkgs.nixd
    ];

    services.emacs.enable = true;

    programs.emacs = {
      enable = true;
      #    extraPackages = epkgs: [ epkgs.evil ];
      package = (pkgs.emacsWithPackagesFromUsePackage {

        config = ./emacs.el;

        defaultInitFile = true;

        extraEmacsPackages = epkgs: [
          epkgs.visual-replace ];

      });
    };
  };
}
