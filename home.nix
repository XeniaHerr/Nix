{ config, pkgs,  inputs, ... }:

let
  #  nixvim = import (builtins.fetchGit {
  #  url = "https://github.com/nix-community/nixvim";
  # });

  # Wind2 = import ./Wind2/default.nix {inherit pkgs;};



  

  dmenu_patched = pkgs.dmenu.overrideAttrs ( {
    patches = [ ./dmenu-patches/nushell.diff
    (pkgs.fetchpatch {

      url ="https://tools.suckless.org/dmenu/patches/fuzzymatch/dmenu-fuzzymatch-5.3.diff";
      hash = "sha256-uPuuwgdH2v37eaefnbQ93ZTMvUBcl3LAjysfOEPD1Y8=";
    })
                ];
  }
    
    );
  #tex = (pkgs.texlive.combine {
  # inherit (pkgs.texlive) scheme-full graphviz xifthen minted;
  #  });
   tex = pkgs.texlive.withPackages (p: with p; [ scheme-full minted listing graphviz]); 
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "xenia";
  home.homeDirectory = "/home/xenia";

  #services.pueue.enable = true;

  nixpkgs.config = {
    allowUnfreePredicate = _:  true;
    allowUnfree = true;
  };


  nixpkgs.overlays = [
      #(import (builtins.fetchTarball {
    # url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
    # }))
  ]
  ;


  imports = [ 
    ./git.nix 
    ./zsh.nix
    ./kitty.nix
    ./fastfetch.nix
    ./i3.nix
    # For home-manager
    #nixvim.homeManagerModules.nixvim
    # <catppuccin/modules/home-manager>
    ./nixvim.nix
    ./btop.nix
    ./tmux.nix
    # ./Wind2/Wind.nix
    #./emacs.nix 
    ./nushell.nix
    ./fish.nix
    ./hyprland.nix
    ./orkan/orkanmodule.nix
    ./ranger.nix
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
    #(pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" "Iosevka" "Mononoki" ]; })
    pkgs.nerd-fonts.mononoki
    pkgs.nerd-fonts.iosevka
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.envy-code-r

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    (pkgs.writeShellScriptBin "univpn" ''
      #!/usr/bin/env bash

      LOCAL_SESSION_KEY=$(${pkgs.bitwarden-cli}/bin/bw unlock --raw)

      LOCAL_PASSWORD=$(bw get password VPN --session $LOCAL_SESSION_KEY)

      LOCAL_TOTP=$(bw get totp VPN --session $LOCAL_SESSION_KEY)

      bw lock

      echo -e "$LOCAL_PASSWORD\n$LOCAL_TOTP" | sudo ${pkgs.openconnect}/bin/openconnect vpn-ac.urz.uni-heidelberg.de --protocol='anyconnect' --useragent='AnyConnect' --user='dd272' --passwd-on-stdin

    '')

    pkgs.ghostscript

    pkgs.betterdiscord-installer
    pkgs.discord
    pkgs.eww
    pkgs.ripgrep
    pkgs.clang-tools
    pkgs.pavucontrol
    pkgs.gcc
    pkgs.rustc
    pkgs.bitwarden-desktop
    pkgs.bitwarden
    pkgs.bitwarden-cli
    pkgs.wpa_supplicant_gui
    #pkgs.texlive.combined.scheme-full
    tex
    pkgs.texlivePackages.graphviz


    pkgs.wl-clipboard


    pkgs.man-pages
    pkgs.man-pages-posix
    #(pkgs.callPackage ./Wind2/default.nix {})
#    (pkgs.callPackage ./orkan/default.nix {}) # THis might also not be nececcary
    pkgs.direnv
    pkgs.flameshot
    pkgs.youtube-music
    pkgs.cliphist
    pkgs.socat
    #pkgs.gh
    #pkgs.ranger

    #dmenu_patched
    pkgs.dmenu


    pkgs.goldwarden


    pkgs.bat
    pkgs.dust


    pkgs.nodejs
    pkgs.zathura


    pkgs.xclip
    pkgs.openconnect
    #pkgs.hyprpaper


    pkgs.manix
    #    pkgs.nu_scripts



  ];





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
  #  /etc/profiles/per-user/xenid/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };


  # Wind test
  #xsession.windowManager.Wind.enable = true;

    #xsession.windowManager.Wind.config = {
    # WindowGap = 5;

    #  TopicNames = [ "This" "is" "a" "Test" ];


    #  Keys = [

    # {
    #   key = "p";

    #   argument = "dmenu_run";

    #   modifiers = [ "Mod"];

    #   action = "spawn";
    # }

    # {key = "q";

    #  action = "quit";

    #  modifiers = ["Mod" "Shift"];

    #  argument = 10;
    #  }
    #  ];
  # };
  
  programs.orkan.enable = true;

  

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
