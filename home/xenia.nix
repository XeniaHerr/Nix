{ config, pkgs,  inputs, specialArgs, lib,  ... }:

let
  
  pdf2dsc-ps = pkgs.writeTextFile {name =  "pdf2dsc-ps";
                                       text = ''
% Copyright (C) 2001-2023 Artifex Software, Inc.
% All Rights Reserved.
%
% This software is provided AS-IS with no warranty, either express or
% implied.
%
% This software is distributed under license and may not be copied,
% modified or distributed except as expressly authorized under the terms
% of the license contained in the file LICENSE in this distribution.
%
% Refer to licensing information at http://www.artifex.com or contact
% Artifex Software, Inc.,  39 Mesa Street, Suite 108A, San Francisco,
% CA 94129, USA, for further information.
%

% pdf2dsc.ps
% read pdf file and produce DSC "index" file.
%
% Input  file is named PDFname
% Output file is named DSCname
%
% Run using:
%  gs -dNODISPLAY -sPDFname=pdffilename -sDSCname=tempfilename pdf2dsc.ps
% Then display the PDF file with
%  gs tempfilename
%
% Modified by Jason McCarty, bug 688071
%       Add PageLabels support.
% Modified by Geoff Keating <geoffk@ozemail.com.au> 21/12/98:
%	Add DocumentMedia, PageMedia comments
%	Use inherited BoundingBox and Orientation
%	Reformat, add new macro 'puts', generally clean up
% Modified by Johannes Plass <plass@dipmza.physik.uni-mainz.de> 1996-11-05:
%	Adds BoundingBox and Orientation if available.
% Modified by rjl/lpd 9/19/96
%	Updates for compatibility with modified pdf_*.ps code for handling
%	 page ranges (i.e., partial files) better.
% Modified by Geoff Keating <Geoff.Keating@anu.edu.au> 7/3/96:
%	include Title and CreationDate DSC comments (these are displayed by
%	 Ghostview);
%	reduce the size of typical output files by a factor of about 3.
% Modified by L. Peter Deutsch 3/18/96:
%	Removes unnecessary and error-prone code duplicated from pdf_main.ps
% Modified by L. Peter Deutsch for GS 3.33
% Originally by Russell Lang  1995-04-26

/PDFfile PDFname (r) file def
/DSCfile DSCname (w) file def
systemdict /.setsafe known { .setsafe } if

/puts { DSCfile exch writestring } bind def
/DSCstring 255 string def
/MediaTypes 10 dict def

   PDFfile runpdfbegin
   /FirstPage where { pop } { /FirstPage 1 def } ifelse
   /LastPage where { pop } { /LastPage pdfpagecount def } ifelse

% scan through for media sizes, keep them in the dictionary
   FirstPage 1 LastPage {
      pdfgetpage /MediaBox pget pop   % MediaBox is a required attribute
      aload pop
      3 -1 roll sub 3 1 roll exch sub exch
      2 array astore
      aload 3 1 roll 10 string cvs exch 10 string cvs
      (x) 3 -1 roll concatstrings concatstrings cvn
      MediaTypes 3 1 roll exch put
   } for

% write header and prolog
   (%!PS-Adobe-3.0\n) puts
   Trailer /Info knownoget
    {
      dup /Title knownoget
       {
         (%%Title: ) puts
         DSCfile exch write==
       }
      if
      /CreationDate knownoget
       {
         (%%CreationDate: ) puts
         DSCfile exch write==
       }
      if
    }
   if
   % This is really supposed to be sorted by frequency of usage...
   (%%DocumentMedia: )
   MediaTypes {
      exch pop
      1 index puts
      (y) puts dup 1 get DSCstring cvs puts
      (x) puts dup 0 get DSCstring cvs puts
      ( ) puts dup 0 get DSCstring cvs puts
      ( ) puts 1 get DSCstring cvs puts
      ( 70 white ()\n) puts
      pop (%%+ )
   } forall
   pop

   (%%Pages: ) puts
   LastPage FirstPage sub 1 add DSCstring cvs puts
   (\n%%EndComments\n) puts
   (%%BeginProlog\n) puts
   (/Page null def\n/Page# 0 def\n/PDFSave null def\n) puts
   (/DSCPageCount 0 def\n) puts
   (/DoPDFPage {dup /Page# exch store dup dopdfpages } def\n) puts
   (%%EndProlog\n) puts
   (%%BeginSetup\n) puts
   DSCfile PDFname write==only
   ( \(r\) file { DELAYSAFER { .setsafe } if } stopped pop\n) puts
   ( runpdfbegin\n) puts
   ( process_trailer_attrs\n) puts
   (%%EndSetup\n) puts

   /.hasPageLabels false def % see "Page Labels" in the PDF Reference
   Trailer /Root knownoget {
     /PageLabels knownoget {
       /PageLabels exch def
       /.pageCounter 1 def
       /.pageCounterType /D def
       /.pagePrefix () def

       % (TEXT)  .ToLower  (text)  -- convert text to lowercase -- only letters!
       /.ToLower {
         dup length 1 sub  -1 0 {
           1 index exch 2 copy get 2#00100000 or put
         } for
       } def

       % int  .CvAlpha  (int in alphabetic base 26)  -- convert a positive
       % integer to base 26 in capital letters, with 1=A; i.e. A..Z, AA..AZ, ...
       /.CvAlpha { % using cvrs seems futile since this isn't zero-based ...
         [ exch % construct an array of ASCII values, in reverse
         { % the remainder stays on the top of stack
           dup 0 eq { pop exit } if % quit if the value is zero
           dup 26 mod dup 0 eq { 26 add } if % so that the division is correct
           dup 64 add 3 1 roll sub 26 idiv % save the ASCII value and iterate
         } loop ]
         dup length dup string 3 1 roll
         dup -1 1 { % put the letters in a string
           4 copy sub exch 4 -1 roll 1 sub get put
         } for pop pop
       } def

       % int  .CvRoman  (int in capital Roman numerals)
       % convert a positive integer to capital Roman numerals
       % return a decimal string if >= 4000
       /.CvRoman {
         dup DSCstring cvs % start with the decimal representation
         exch 4000 lt { % convert only if Roman numerals can represent this
           dup length
           [ [ () (I) (II) (III) (IV) (V) (VI) (VII) (VIII) (IX) ]
             [ () (X) (XX) (XXX) (XL) (L) (LX) (LXX) (LXXX) (XC) ]
             [ () (C) (CC) (CCC) (CD) (D) (DC) (DCC) (DCCC) (CM) ]
             [ () (M) (MM) (MMM) ] ] % Roman equivalents
           () % append the Roman equivalent of each decimal digit to this string
           2 index  -1 1 {
             2 index 1 index 1 sub get
             5 index 5 index 4 -1 roll sub get
             48 sub get concatstrings
           } for
           4 1 roll pop pop pop
         } if
       } def

       /PageToString <<
         /D { DSCstring cvs }
         /R { .CvRoman }
         /r { .CvRoman .ToLower }
         /A { .CvAlpha }
         /a { .CvAlpha .ToLower }
       >> def
       /.hasPageLabels true def
     } if
   } if

   % process each page
   FirstPage 1 LastPage {
       (%%Page: ) puts

       .hasPageLabels {
         dup 1 sub PageLabels exch numoget dup null ne {
           % page labels changed at this page, reset the values
           dup /S known { dup /S get } { null } ifelse
           /.pageCounterType exch def

           dup /P known { dup /P get } { () } ifelse
           /.pagePrefix exch def

           dup /St known { /St get } { pop 1 } ifelse
           /.pageCounter exch def
         } { pop } ifelse

         % output the page label
         (\() .pagePrefix
         .pageCounterType //null ne dup {
           PageToString .pageCounterType known and
         } if { % format the page number
           .pageCounter dup 0 gt { % don't try to format nonpositive numbers
             PageToString .pageCounterType get exec
           } {
             DSCstring cvs
          } ifelse
         } { () } ifelse
         (\)) concatstrings concatstrings concatstrings puts

         /.pageCounter .pageCounter 1 add def
       } {
         dup DSCstring cvs puts
       } ifelse
       ( ) puts
       dup DSCstring cvs puts
       (\n) puts

       dup pdfgetpage
       dup /MediaBox pget pop
         (%%PageMedia: y) puts
         aload pop 3 -1 roll sub DSCstring cvs puts
         (x) puts exch sub DSCstring cvs puts
         (\n) puts
       dup /CropBox pget {
         (%%PageBoundingBox: ) puts
         {DSCfile exch write=only ( ) puts} forall
         (\n) puts
       } if
       /Rotate pget {
         (%%PageOrientation: ) puts
         90 div cvi 4 mod dup 0 lt {4 add} if
         [(Portrait) (Landscape) (UpsideDown) (Seascape)] exch get puts
         (\n) puts
       } if

       DSCfile exch DSCstring cvs writestring
       ( DoPDFPage\n) puts
    } for
    runpdfend
% write trailer
(%%Trailer\n) puts
(runpdfend\n) puts
(%%EOF\n) puts
% close output file and exit
DSCfile closefile
quit
% end of pdf2dsc.ps
                 '';
                                      };

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
LOCAL_PASSWORD=$(bw get password VPN --session $LOCAL_SESSION_KEY )

      LOCAL_TOTP=$(bw get totp VPN --session $LOCAL_SESSION_KEY)

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

    (writeShellScriptBin "pdf2dsc" ''
#!/nix/store/4k90qpzh1a4sldhnf7cxwkm9c0agq4fp-bash-interactive-5.2p37/bin/sh

# pdf2dsc: generates an index of a PDF file.
#
# Yves Arrouye <arrouye@debian.org>, 1996.
# 2000-05-18 lpd <ghost@aladdin.com> added -dSAFER

# This definition is changed on install to match the
# executable name set in the makefile
GS_EXECUTABLE=gs
gs="`dirname \"$0\"`/$GS_EXECUTABLE"
if test ! -x "$gs"; then
	gs="$GS_EXECUTABLE"
fi
GS_EXECUTABLE="${ghostscript}/bin/gs"

me=`basename $0`

usage() {
    >&2 echo usage: $me "pdffile [ dscfile ]"
    exit 1
}

if [ $# -gt 2 ]
then
    usage
fi

pdffile=$1
dscfile=$2
: ''${dscfile:=`echo $pdffile | sed 's,\.[^/.]*,,'`.dsc}

exec "$GS_EXECUTABLE" -q -dNODISPLAY -P- -dSAFER -dDELAYSAFER\
    -sPDFname="$pdffile" -sDSCname="$dscfile" ${pdf2dsc-ps} -c quit
                 '')


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
      #tex
    texlivePackages.graphviz

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
    #desktop.dunst = true;
    desktop.waybar = true;
    desktop.wayland.notifications = "dunst";

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
    };
  };
  

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = pkgs.lib.mkForce true;
}
