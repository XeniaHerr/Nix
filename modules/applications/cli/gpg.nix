{pkgs, lib, config, ...}:

with lib;
{
  options = {
    host.applications.gpg = {
      enable = mkEnableOption "Enable GPG";

      ssh = mkOption {
        type = types.bool;
        default = false;
        description = ''
    Use GPG as a ssh backend
        '';
      };
    };
  };

  config = mkIf config.host.applications.gpg.enable {
  home.packages = [
    pkgs.gpg-tui
      pkgs.gnupg
    ];

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = config.host.applications.gpg.ssh;
    };

  };
}
