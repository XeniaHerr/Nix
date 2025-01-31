{config, pkgs, lib,...}:


{ 


  options = {
    host.settings.shell = lib.mkOption {
      type = lib.types.nonEmptyStr;
      description = "Default shell that is enabled";
    };
  };
  imports = [
    ./zsh.nix
    ./fish.nix
    ./nushell.nix
    ./aliases.nix
  ];}
