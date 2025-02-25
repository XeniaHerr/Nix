{inputs,lib, config, ...}:
with lib;
{

  imports = [
    inputs.nix-colors.homeManagerModules.default
    inputs.base16.homeManagerModule {
      scheme = "${inputs.tt-schemes}/base24/nord.yaml";
    }
  ];

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


}
