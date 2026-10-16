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
      pkgs.tinymist
      pkgs.java-language-server
      pkgs.maven
      pkgs.pandoc

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
        override = epkgs: epkgs //  {
          typst-preview = pkgs.callPackage ./typst-preview.nix {
            inherit (pkgs) fetchFromGitHub;
            inherit (epkgs) melpaBuild websocket f;};
          lean-4-mode = pkgs.callPackage ./lean4-mode.nix {
            inherit (pkgs) fetchFromGithub;
            inherit (epkgs) melpaBuild;};
        nael-mode = pkgs.callPackage ./nael-mode.nix {
          inherit (pkgs) fetchgit;
          inherit (epkgs) melpaBuild;};
        };
        extraEmacsPackages = epkgs: [
          epkgs.visual-replace
          epkgs.treesit-grammars.with-all-grammars
          epkgs.typst-preview
          #          epkgs.lean-4-mode
          #          epkgs.nael-mode
          epkgs.nael

          #epkgs.websocket
        ];


      });
    };
  };
}
