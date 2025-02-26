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

    base16 = {
      url = "github:SenchoPens/base16.nix";
    };

    tt-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };

    base16-nvim = {
      url = "github:tinted-theming/tinted-vim";
      flake = false;
    };

    base16-zathura = {
      url = "github:haozeke/base16-zathura";
      flake = false;
    };

    base16-kitty = {
      url = "github:kdrag0n/base16-kitty";
      flake = false;
    };




    #    hyprland.url = "github:hyprwm/Hyprland";
    #  hyprland.inputs.nixpkgs.follows = "nixpkgs";
    # hyprland-plugins = {
    #  url = "github:hyprwm/hyprland-plugins";
    #  inputs.hyprland.follows = "hyprland";
    # };
  };


  outputs =  inputs @ { self, nixpkgs, home-manager, catppuccin, flake-utils, ...}: 
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
             (import ./home/xenia.nix)
            (import ./modules)
            catppuccin.homeManagerModules.catppuccin 
          ];

          extraSpecialArgs = {
            mywindowManager = "Hyprland";
            myscheme = "catppuccin-mocha";
            inherit inputs;
          };

          };
        };
    };
}
