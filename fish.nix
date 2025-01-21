{config, pkgs, ...}:
{
  programs.fish =  {
    enable = true;

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
