{inputs,lib, config, ...}:
with lib;
{

  imports = [
    inputs.nix-colors.homeManagerModules.default
  ];

  options = {

    host.features.theming.enable = mkEnableOption "Colorscheme support";


    host.features.theming.scheme = mkOption {
      type = types.nonEmptyStr;
      default = "";
      description = "What colorscheme should be used";
    };


  };


  config  = mkIf host.features.theming.enable {

    colorScheme = inputs.nix-colors."${host.featurs.theming.scheme}";

  };


}
