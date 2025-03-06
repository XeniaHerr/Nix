{ config, pkgs,  inputs, specialArgs, lib,  ... }:

let
  

   tex = pkgs.texlive.withPackages (p: with p; [ scheme-full minted listing graphviz]); 
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


  nixpkgs.overlays = [
      #(import (builtins.fetchTarball {
    # url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
    # }))
  ]
  ;


  imports = [ 
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

      LOCAL_SESSION_KEY=$(${bitwarden-cli}/bin/bw unlock --raw)

      LOCAL_PASSWORD=$(bw get password VPN --session $LOCAL_SESSION_KEY)

      LOCAL_TOTP=$(bw get totp VPN --session $LOCAL_SESSION_KEY)

      bw lock

      echo -e "$LOCAL_PASSWORD\n$LOCAL_TOTP" | sudo ${openconnect}/bin/openconnect vpn-ac.urz.uni-heidelberg.de --protocol='anyconnect' --useragent='AnyConnect' --user='dd272' --passwd-on-stdin

    '')

    ghostscript

    betterdiscord-installer
    discord
    eww
    ripgrep
    clang-tools
    pavucontrol
    gcc
    rustc
    bitwarden-desktop
    bitwarden
    bitwarden-cli
    wpa_supplicant_gui
    tex
    texlivePackages.graphviz


    wl-clipboard


    man-pages
    man-pages-posix
    direnv
    youtube-music
    cliphist
    socat
    goldwarden
    bat
    dust
    nodejs
    zathura
    manix
  ];



  host = {

    settings.shell = "zsh";

    shells.aliases.enable = true;
    shells.aliases.aliases = {
      lll = "ls -ahl";
      lg = "lazygit";
      mytest = "echo Hello World";
    };


    features.development.enable = true;

    #features.security.enable = true;

    #    features.theming.enable = true;

    #features.theming.scheme = "catppuccin-mocha";

    desktop.wayland.enable = if mywindowManager == "Hyprland" then lib.mkDefault true else lib.mkDefault false; 
    desktop.enable = true;
    desktop.dunst = true;
    desktop.waybar = true;

    applications.kitty.enable = true;
    applications.btop.enable = true;
    applications.fastfetch.enable = true;
    applications.zathura.enable = true;
    applications.iamb.enable = true;
    applications.iamb.extraConfig = ''
      [settings.users]
      "@dd272:matrix-im.uni-heidelberg.de" = { "name" = "Kenneth Herr"}
    '';

    applications.iamb.profiles = [
      {
        name = "dd272";
        domain = "matrix-im.uni-heidelberg.de";
      }
    ];

    shells.nushell.enable = true;
  };



  home.sessionVariables = {
    EDITOR = "nvim";
  };


  
  programs.orkan.enable = true;

  

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = pkgs.lib.mkForce true;
}
