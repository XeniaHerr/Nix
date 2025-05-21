{config, pkgs, lib,inputs, ...}:
  let
  cfg = config.host.secrets;
in
with lib;
{
  imports = [inputs.nix-sops.homeManagerModules.sops];
}
