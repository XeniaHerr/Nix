{config, pkgs, lib,  ...}: {


  options = {
    host.applications.ranger.enable = lib.mkEnableOption "ranger";
  };
  config = lib.mkIf config.host.applications.ranger.enable {

  programs.ranger = {
    enable = true;

    plugins = [
      { name = "ranger_devicons";
        src = builtins.fetchGit {
          url = "https://github.com/alexanderjeurissen/ranger_devicons";
          # ref = "HEAD";
          rev = "f227f212e14996fbb366f945ec3ecaf5dc5f44b0";
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
  };
}
