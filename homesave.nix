{ config, pkgs,  inputs, ... }:

let
  

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
    ./zsh.nix
    ./kitty.nix
    # For home-manager
    #nixvim.homeManagerModules.nixvim
    # <catppuccin/modules/home-manager>
    # ./Wind2/Wind.nix
    #./emacs.nix 
    ./nushell.nix
    ./fish.nix
    ./orkan/orkanmodule.nix
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
    #texlive.combined.scheme-full
    tex
    texlivePackages.graphviz


    wl-clipboard


    man-pages
    man-pages-posix
    direnv
    flameshot
    youtube-music
    cliphist
    socat
    #gh
    #ranger

    #dmenu_patched
    dmenu


    goldwarden


    bat
    dust


    nodejs
    zathura


    xclip
    openconnect
    #hyprpaper


    manix
    #    nu_scripts



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


  
  programs.orkan.enable = true;

  

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = pkgs.lib.mkForce true;
}
