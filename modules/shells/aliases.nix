{config, pkgs, lib, ...}:


# Central point to collect shell aliases and provide them as a sourcable file
# or wait. i simpy can provide them as a attr set for the shells to handle...
with lib;
{


  options.host.shells.aliases = {

    enable = mkEnableOption "aliases";

  aliases = mkOption {
  description = ''
    Attribute set of aliases for different shells
    '';
    type = types.attrsOf types.string;
      example = ''
        aliases = {
        ls = "ls -alh"
        }
      '';
      default = {};
  };
  };


}
