{config, pkgs, lib, ...}:


with lib;
{


  options.host.applications.fzf.enable = mkEnableOption "fzf";


  config =  mkIf (config.host.applications.fzf.enable) {

    programs.fzf = {
      enable = true;

    defaultOptions = [ "--ansi" "--border=double"];
    };

  };
}
