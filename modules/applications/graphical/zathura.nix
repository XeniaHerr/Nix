{pkgs, lib, config, inputs, ...}:
with lib;
{
  options.host.applications.zathura.enable = mkEnableOption "Zathura";

  config = mkIf config.host.applications.zathura.enable {
    programs.zathura.enable = true;

    programs.zathura.extraConfig = builtins.readFile (config.scheme inputs.base16-zathura);

  };
}
