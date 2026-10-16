{


  description = "Home Manger Configuration for Xenia :)";

  nixConfig = {
    experimental-features = [
      "flakes"
      "nix-command"
    ];

  };
  inputs = {


    my-bar = {
      url = "github:XeniaHerr/niri-quickshell";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
  #    inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    caelestia = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ax-shell = {
    #   url = "git+file:///home/xenia/Projects/Ax-Shell";

    #   inputs.nixpkgs.follows = "nixpkgs";};


    niri = {
      url  ="github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };


  };

  outputs =  inputs @ { self, nixpkgs, home-manager, catppuccin, flake-utils, ...}: 
    let 
      system = "x86_64-linux";

      
      pkgs = import nixpkgs {inherit system;overlays = [inputs.emacs-overlays.overlays.default 
                                                       inputs.niri.overlays.niri ];
                            config.allowUnfree = true;};
    in 
      flake-utils.lib.eachSystem [ system ] (system: rec {
        legacyPackages = import nixpkgs { inherit system; };


      })
    //
    {

      homeConfigurations = {
        "xenia" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [ 
            (import ./home/xenia.nix)
            (import ./modules)
            inputs.caelestia.homeManagerModules.default
#            inputs.sops-nix.homeManagerModules.default
            #            inputs.ax-shell.homeManagerModules.default
            inputs.niri.homeModules.niri
            catppuccin.homeModules.catppuccin

            # inputs.base16.homeManagerModule {
            #   scheme = "${inputs.tt-schemes}/base16/catppuccin-mocha.yaml";}
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
















