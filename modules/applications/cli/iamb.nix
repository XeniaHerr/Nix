{pkgs, lib, config, ...}:
with lib;
let 
  cfg = config.host.applications.iamb;
  profileReader = {name, domain, url}: ''
    [profiles."${domain}"]
    user_id = "@${name}:${domain}"
  '' + optionalString (url != null) ''
      url = https://${url}
    '';

in
{

  options.host.applications.iamb = {
    enable = mkEnableOption "enable Iamb matrix client";


    profiles = mkOption {
      description = "Different Profiles you want to use";
      type = types.listOf (types.submodule ({config, ...}: {
        options = {
        name = mkOption {
          type = types.string;
        };
        domain = mkOption {
          type = types.string;
        };
        url = mkOption {
          type = types.nullOr types.string;
            default = null;
        };
        };
      }));
    };


    extraConfig = mkOption {
      type = types.str;
      description = "ExtraConfig to be appended at the end. Must be valid TOML";
      default = "";
    };
  };


  config = mkIf config.host.applications.iamb.enable {

    home.packages = [ pkgs.iamb];

    xdg.configFile."iamb/config.toml".source = pkgs.writeText "config.toml" ''
      ${builtins.concatStringsSep"\n\n" (builtins.map profileReader config.host.applications.iamb.profiles)}


      ${cfg.extraConfig}
    '' ;
  };
}
