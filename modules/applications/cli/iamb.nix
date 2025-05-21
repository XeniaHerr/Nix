{pkgs, lib, config, ...}:
with lib;
let 
  cfg = config.host.applications.iamb;

  tomlFormat = pkgs.formats.toml { } ;


in
  {

  options.host.applications.iamb = {
    enable = mkEnableOption "enable Iamb matrix client";


    profiles = mkOption {
      description = "Profiles for various servers";
      type = types.attrsOf (types.submodule {
        options = {
          name = mkOption {
            type = types.str;
            description = "username";
          };
          url = mkOption {
            type = types.nullOr types.str;
            description = "Alternate Homeserver";
            default = null;
          };

        };
      });
      default = {
        "test" = {
          name = "Myname";
        };
        "second" = {
          name = "second Name";
          url = "Second URL";
        };
      };

    };

    settings = mkOption {
      description = "I am eating a broom if this works";
      type = tomlFormat.type;
      default = {
        love = 42;
        my_life = {
          first = "Meaningless";
          second = 69;
        };
      };
    };

    extraConfig = mkOption {
      type = types.str;
      description = "ExtraConfig to be appended at the end. Must be valid TOML";
      default = "";
    };
  };


  config = let

    prependat = s: if lib.strings.hasPrefix "@" s then
      s
    else
      "@" + s;


    filteremptyattrs = attrs:  mapAttrs ( name: value: filterAttrs (_: v: v != null) value ) attrs;

    replacenames = attrs: mapAttrs ( n: value: removeAttrs value ["name"] // { user_id = "${prependat value.name}:${n}";}  ) attrs;


    finalprofiles2 = replacenames ( filteremptyattrs cfg.profiles);
    filecontents =  cfg.settings // { profiles = finalprofiles2;} ;
    configSource = tomlFormat.generate "iamb-config.toml" filecontents;
  in mkIf config.host.applications.iamb.enable {

      home.packages = [ pkgs.iamb ];
      /*
xdg.configFile."iamb/config.toml".source = pkgs.writeText "config.toml" '' ${builtins.concatStringsSep"\n\n" (builtins.map profileReader config.host.applications.iamb.profiles)}

${SettingsReader config.host.applications.iamb.settings}


${cfg.extraConfig}
*/
      xdg.configFile."iamb/config.toml" = {
        source = configSource;
      };
    };
}
