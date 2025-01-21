{pkgs,lib, config, ...}:

let cfg = config.programs.orkan;

in
  {
  options.programs.orkan = 

    {

      enable = lib.mkEnableOption "orkan";
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.callPackage ./default.nix {};
      };

    };
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
};
}
