{config, pkgs, ...}:
{
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
}
