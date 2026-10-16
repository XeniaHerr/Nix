{config, pkgs, lib, ...}:

# List of Applications that i need to develop
{


options = {
  host = {
  features = {

    development.enable = lib.mkEnableOption "development";
  };
  };

};


  config = lib.mkIf config.host.features.development.enable {
  
    host.applications =  with lib; {

      git.enable = mkDefault true;
      nvim.enable = mkDefault true;
      tmux.enable = mkDefault true;
      btop.enable = mkDefault true;
    };


    home.packages = with pkgs; [


      # teleport und gopass für die Fachschaft
      teleport
      gopass

      gcc
      rustc
      (      python3.withPackages (py-Packages: [ py-Packages.numpy py-Packages.jupyterlab py-Packages.matplotlib
                                                  py-Packages.bcrypt
                                                  py-Packages.manim
                                                  py-Packages.manim-slides
                                                  py-Packages.typst
                                                ])      )
      basedpyright
      lean4
#b      (coq.withPackages ( ps: [ ps.coq-lsp ps.stdlib]))
      rust-analyzer
      cargo
      typescript-language-server
      cloc
#      coqPackages.coq-lsp

#      jupyter
      clang-tools
      nodejs
      cmake
      gnumake


      go
      #Haskell stuff
      ghc
      haskell-language-server
      cabal-cli
      

    ];
  };
    
  }
