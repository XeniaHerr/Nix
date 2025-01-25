{


  description = "Home Manger Configuration for Xenia :)";

  nixConfig = {
    experimental-features = [
      "flakes"
      "nix-command"
    ];

  };
  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    catppuccin = {
      url = "github:catppuccin/nix";
    };


    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };


  outputs = { self, nixpkgs, home-manager, nixvim, catppuccin, flake-utils, ...}: 
      let 
        system = "x86_64-linux";
        pkgs = import nixpkgs {inherit system;};
      in 
      flake-utils.lib.eachSystem [ system ] (system: rec {
        legacyPackages = import nixpkgs { inherit system;};
      })
     //
        {
        homeConfigurations = {
          "xenia" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;

          modules = [ 
            ./home.nix
            catppuccin.homeManagerModules.catppuccin 
            nixvim.homeManagerModules.nixvim 
          ];

          };
        };
    };
}
