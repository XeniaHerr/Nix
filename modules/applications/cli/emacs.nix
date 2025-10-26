{config,pkgs, lib,...}:

with lib;
{

  options.host.applications.cli.emacs.enable = mkEnableOption "Emacs";

  config = mkIf config.host.applications.cli.emacs.enable {


    home.packages = [
      pkgs.nixd
      pkgs.ripgrep
      pkgs.direnv
      pkgs.lorri
      pkgs.cmake-language-server
      pkgs.zip
      pkgs.emacs-lsp-booster
      pkgs.ripgrep
    ];

    services.lorri.enable = true;

    services.emacs.enable = true;
    services.emacs.client.enable = true;
    services.emacs.startWithUserSession = "graphical";
#    services.emacs.defaultEditor = lib.mkForce true;

    programs.emacs = {
      enable = true;
      #    extraPackages = epkgs: [ epkgs.evil ];
      package = (pkgs.emacsWithPackagesFromUsePackage {

        config = ./emacs.el;

        defaultInitFile = true;

        extraEmacsPackages = epkgs: [
          epkgs.visual-replace
          epkgs.treesit-grammars.with-all-grammars
        ];


      });
    };
  };
}
