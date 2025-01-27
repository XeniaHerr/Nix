{config, pkgs,lib, ...}:


{

  options.host.shell.fish.enable = lib.mkEnableOption "fish";

  config = lib.mkIf (config.host.settings.shell == "fish" || config.host.shell.fish.enable) {
  programs.fish =  {
    enable = false;

    interactiveShellInit = ''
    set fish_greeting
    '';

    generateCompletions = true;

    shellInitLast = ''
    zoxide init fish | source
    starship init fish | source
    '';

  };
  };
}
