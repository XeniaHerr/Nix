{inputs,lib, config,specialArgs, ...}:
let
  inherit (specialArgs) myscheme;
in
{

  imports = [
    #    inputs.nix-colors.homeManagerModules.default
    inputs.base16.homeManagerModule {
      scheme =  { yaml = "${inputs.tt-schemes}/base24/${myscheme}.yaml";
        use-ifd = "auto";
      };
    }
  ];
/*
  options = {

    host.features.theming.enable = mkEnableOption "Colorscheme support";


    host.features.theming.scheme = mkOption {
      type = types.nonEmptyStr;
      default = "";
      description = "What colorscheme should be used";
    };


  };


  config  = mkIf config.host.features.theming.enable {

    colorScheme = inputs.nix-colors.colorSchemes."${config.host.features.theming.scheme}";

  };

  */

}
