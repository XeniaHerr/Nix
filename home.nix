{ config, pkgs, ... }:

let
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
    # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
     ref = "nixos-24.05";
  });

  Wind2 = import ./Wind2/default.nix {inherit pkgs;};


  dmenu_patched = pkgs.dmenu.overrideAttrs ( {
    patches = [ ./dmenu-patches/nushell.diff
    (pkgs.fetchpatch {

      url ="https://tools.suckless.org/dmenu/patches/fuzzymatch/dmenu-fuzzymatch-5.3.diff";
      hash = "sha256-uPuuwgdH2v37eaefnbQ93ZTMvUBcl3LAjysfOEPD1Y8=";
    })
#    (pkgs.fetchpatch {
 #     url = "https://tools.suckless.org/dmenu/patches/fuzzyhighlight/dmenu-fuzzyhighlight-5.3.diff";
  #    hash ="sha256-YdXuqqxF3MdfRfYPcyXLkWKqLDBJ6SNv4fMBoIQ+UNE=";
   # })
   # These two patches dont work together. I have to manually patch them into a single patc and apply it locally.
                ];
  }
    );
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "xenia";
  home.homeDirectory = "/home/xenia";


  imports = [ 
    ./git.nix 
    ./zsh.nix
    ./kitty.nix
    ./fastfetch.nix
    ./i3.nix
    # For home-manager
    nixvim.homeManagerModules.nixvim
    <catppuccin/modules/home-manager>
    ./nixvim.nix
    ./btop.nix
    ./tmux.nix
    ./Wind2/Wind.nix
    ./nushell.nix
  ];
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.ty

  gtk.enable = true;

  #Colorsheme
  #catppuccin.enable = true;
  #gtk.catppuccin.enable = true;


  fonts.fontconfig.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
     (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" "Iosevka" "Mononoki" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')


    pkgs.betterdiscord-installer
    pkgs.discord
    pkgs.eww
    pkgs.ripgrep
    pkgs.clang-tools
    pkgs.pavucontrol
    pkgs.nitrogen
    pkgs.gcc
    pkgs.rustc
    pkgs.cargo
    pkgs.bitwarden-desktop
    pkgs.bitwarden
    pkgs.bitwarden-cli
    pkgs.wpa_supplicant_gui
    pkgs.texlive.combined.scheme-full
    pkgs.man-pages
    pkgs.man-pages-posix
    (pkgs.callPackage ./Wind2/default.nix {})
    pkgs.direnv

    #pkgs.dmenu.override { patches = [ ./dmenu-patches/nushell.diff];}
    dmenu_patched



    pkgs.bat
    pkgs.dust


    pkgs.nodejs
    pkgs.zathura


    pkgs.xclip
    pkgs.openconnect


    pkgs.manix

  ];

#documentation.dev.enable = true;
  
#programs.dmenu.enable = true;

#programs.dmenu.package = pkgs.dmenu.override {

 # patches = [ ./dmenu-patches/nushell.diff];

#};
  programs.emacs.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };
  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/xenia/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
     EDITOR = "nvim";
  };


  # Wind test
  xsession.windowManager.Wind.enable = true;

  xsession.windowManager.Wind.config = {
    WindowGap = 5;

    TopicNames = [ "This" "is" "a" "Test" ];


    Keys = [

      {
        key = "p";

        argument = "dmenu_run";

        modifiers = [ "Mod"];

        action = "spawn";
      }

      {key = "q";

      action = "quit";

    modifiers = ["Mod" "Shift"];

    argument = 10;
  }
    ];
  };
  
  

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
