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

    sops-nix = {
      url = "github:Mic92/sops-nix";
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

    base16-rofi = {
      url = "github:tinted-theming/base16-rofi";
      flake = false;
    };


    emacs-overlays = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    fabric = {
      url = "github:Fabric-Development/fabric";
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
      pkgs = import nixpkgs {inherit system;overlays = [inputs.emacs-overlays.overlays.default];
                            config.allowUnfree = true;};
    in 
      flake-utils.lib.eachSystem [ system ] (system: rec {
        legacyPackages = import nixpkgs { inherit system; };

        devShells.default = inputs.fabric.devShells."${system}".default;
      })
    //
    {

      homeConfigurations = {
        "xenia" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [ 
            (import ./home/xenia.nix)
            (import ./modules)
            catppuccin.homeModules.catppuccin 
          ];

          extraSpecialArgs = {
            mywindowManager = "Hyprland";
            myscheme = "catppuccin-mocha";
            yubikey_id = ["32244578"];
            inherit inputs system;
          };

        };
      };

    };
}
