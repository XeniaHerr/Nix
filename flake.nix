{


  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
  };


  outputs = { self, nixpkgs, home-manager, ...}:
    let 
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system;};
    in 
    {
      homeConfigurations = {
        "xenia" = home-manager.lib.homeManagerConfiguration {
          inherit system;
          nixkpgs.path = nixpkgs;
          configuration = ./home.nix;

        };

      };
    };
}
