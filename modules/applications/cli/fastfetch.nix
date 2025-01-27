{config, pkgs,lib, ... }:

{

  options = {host.applications.fastfetch.enable = lib.mkEnableOption "fastfetch";
  };

  config = lib.mkIf config.host.applications.fastfetch.enable {

programs.fastfetch = {

    enable = true;


};
  };
}
