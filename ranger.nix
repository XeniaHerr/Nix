{config, pkgs, lib,  ...}: {

  programs.ranger = {
    enable = true;

    plugins = [
      { name = "ranger_devicons";
        src = builtins.fetchGit {
          url = "https://github.com/alexanderjeurissen/ranger_devicons";
          ref = "HEAD";
        };
      }
    ];

    settings = {
      show_hidden = true;
    };

    extraConfig = ''
      default_linemode devicons
    '';
  };
}
