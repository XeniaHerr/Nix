{ config, pkgs,  inputs, specialArgs, lib,  ... }:

let
  

  # tex = pkgs.texlive.withPackages (p: with p; [ scheme-full minted listing graphviz multidef]); 
  inherit (specialArgs) mywindowManager;
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


  #nixpkgs.overlays = [
      # (import (builtins.fetchTarball {
    # url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
    # }))
  #]
  #;


  imports = [ 
    inputs.sops-nix.homeManagerModules.sops
  ];
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.ty

  gtk = {
    enable = true;
      theme = {
       name = "Tokyonight-Dark";
      package = pkgs.tokyo-night-gtk;
    };

    iconTheme = {
      package = pkgs.libsForQt5.breeze-icons;
      name = "breeze-dark";
    };
  };




  fonts.fontconfig.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.



  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    #(nerdfonts.override { fonts = [ "FantasqueSansMono" "Iosevka" "Mononoki" ]; })
    nerd-fonts.mononoki
    nerd-fonts.iosevka
    nerd-fonts.jetbrains-mono
    nerd-fonts.envy-code-r

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    (writeShellScriptBin "univpn" ''
      #!/usr/bin/env bash

      #      masterpw=$(cat ${config.sops.secrets."passwords/masterpassword".path})

      ${bitwarden-cli}/bin/bw login xeniaherr@gmail.com --passwordfile "${config.sops.secrets."passwords/masterpassword".path}" --raw
      LOCAL_SESSION_KEY=$(${bitwarden-cli}/bin/bw unlock  --passwordfile "${config.sops.secrets."passwords/masterpassword".path}" --raw)
LOCAL_PASSWORD=$(bw get password  89b6f4f0-e2ad-4bbb-95f8-b1a601383065 --session $LOCAL_SESSION_KEY )

      LOCAL_TOTP=$(bw get totp 89b6f4f0-e2ad-4bbb-95f8-b1a601383065 --session $LOCAL_SESSION_KEY)

      bw lock

      bw logout

      sudo_password=$(cat ${config.sops.secrets."passwords/Unipassword".path})

      echo -e "$LOCAL_PASSWORD\n$LOCAL_TOTP" | sudo ${openconnect_gnutls}/bin/openconnect vpn-ac.urz.uni-heidelberg.de --protocol='anyconnect' --useragent='AnyConnect' --user='dd272' --passwd-on-stdin --no-external-auth

    '')

      (writeShellScriptBin "ns" ''
      #!/usr/bin/env bash
      if [[ -z "$1" || "$1" == "--help" ]]; then
        echo "Usage: ns search_string"
        exit 0
      fi
      nix search nixpkgs "$1" --json | ${jq}/bin/jq -c '.[] | {pname, description }' | ${jtbl}/bin/jtbl
      '')

    ghostscript

#     (writeShellScriptBin "pdf2dsc" ''
# #!/nix/store/4k90qpzh1a4sldhnf7cxwkm9c0agq4fp-bash-interactive-5.2p37/bin/sh

# # pdf2dsc: generates an index of a PDF file.
# #
# # Yves Arrouye <arrouye@debian.org>, 1996.
# # 2000-05-18 lpd <ghost@aladdin.com> added -dSAFER

# # This definition is changed on install to match the
# # executable name set in the makefile
# GS_EXECUTABLE=gs
# gs="`dirname \"$0\"`/$GS_EXECUTABLE"
# if test ! -x "$gs"; then
# 	gs="$GS_EXECUTABLE"
# fi
# GS_EXECUTABLE="${ghostscript}/bin/gs"

# me=`basename $0`

# usage() {
#     >&2 echo usage: $me "pdffile [ dscfile ]"
#     exit 1
# }

# if [ $# -gt 2 ]
# then
#     usage
# fi

# pdffile=$1
# dscfile=$2
# : ''${dscfile:=`echo $pdffile | sed 's,\.[^/.]*,,'`.dsc}

# exec "$GS_EXECUTABLE" -q -dNODISPLAY -P- -dSAFER -dDELAYSAFER\
#     -sPDFname="$pdffile" -sDSCname="$dscfile" ${pdf2dsc-ps} -c quit
#                  '')


    betterdiscord-installer
    discord
    eww
    ripgrep
    pavucontrol
    pipewire
      #bitwarden-desktop
    bitwarden
    bitwarden-cli
    wpa_supplicant_gui
    #    ( pkgs.texlive.withPackages (p: with p; [ inherit (pkgs.texlive) scheme-full minted listing graphviz multidef;]) )
    (texlive.combine { inherit (texlive) scheme-full; })
#    (texlive.scheme-full)
    texlivePackages.graphviz
    texlivePackages.multidef
    whatsie



    man-pages
    man-pages-posix
    direnv
      youtube-music
    cliphist
    socat
    bat
    dust
    zathura
    manix


    telegram-desktop


    (writeShellScriptBin "storefind" ''
      #!/usr/bin/env bash

      F=$(which "$1")

      if [ -z "$F" ]; then
           echo "Not a binary";
           exit 1;
      fi

      if [[ $F =~ ^/nix/store.* ]]; then
          echo "$F"
      else
          ${file}/bin/file -b "$F" | awk '{ print $4 }'
      fi
    '')
  ];


  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  host = {

    settings.shell = "zsh";


    applications.nvim.enable = true;

    shells.aliases.enable = true;
    shells.aliases.aliases = {
      lll = "ls -ahl";
      lg = "lazygit";
      mytest = "echo Hello World";
    };


    features.development.enable = true;

    #features.security.enable = true;

    #features.theming.enable = true;

    #features.theming.scheme = "catppuccin-mocha";

    desktop.wayland.enable = if mywindowManager == "Hyprland" then lib.mkDefault true else lib.mkDefault false; 
    desktop.enable = true;
    #desktop.dunst = true;
    desktop.waybar = true;
    desktop.wayland.notifications = "dunst";

    desktop.gnome.enable = true;

    applications.cli.emacs.enable = true;

    applications.kitty.enable = true;

    applications.btop.enable = true;
    applications.fastfetch.enable = true;
    applications.zathura.enable = true;
    applications.iamb.enable = true;
    applications.ranger.enable = true;
    applications.elements.enable = true;
    applications.iamb.extraConfig = ''
      [settings.users]
      "@dd272:matrix-im.uni-heidelberg.de" = { "name" = "Kenneth Herr"}

      [dirs]
      downloads = "/home/xenia/Downloads/"
    '';

    applications.iamb = {
      profiles = {
       "matrix-im.uni-heidelberg.de" = {
        name = "dd272";
         };

      };

      settings =  {
      dirs = {
        downloads = "/home/xenia/Downloads/";
      };
      };
      };

    shells.nushell.enable = true;


        features.mail.enable = true; # This ain't i chief
  };



  home.sessionVariables = {
    EDITOR = "nvim";
  };


  
  programs.orkan.enable = true;


  

  sops = {

    gnupg.home = "/home/xenia/.gnupg";
    defaultSopsFile = ./secrets/xenia.yaml;
    secrets = {

    "passwords/masterpassword" = {
      sopsFile = ./secrets/xenia.yaml;
    };

      "passwords/Unipassword" = {};

      "passwords/Mediumpassword" = {};
      "passwords/gmail" = {};

      "passwords/chatgptapikey" = {};
    };
  };
  

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = pkgs.lib.mkForce true;
}
