{configs, pkgs, ... }: {


  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    syntaxHighlighting.catppuccin.enable = true;

    shellAliases = { 
      ".." = "cd ..";
      la = "ls -Ahl";
      ff = "fastfetch";
      du = "du -h";
    };

    initExtra = ''
    bindkey '^ ' autosuggest-accept
    zstyle ':omz:plugins:alias-finder' autoload yes # disabled by default
    zstyle ':omz:plugins:alias-finder' longer yes # disabled by default
    zstyle ':omz:plugins:alias-finder' exact yes # disabled by default
    zstyle ':omz:plugins:alias-finder' cheaper yes # disabled by default
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" 
      "ssh"
      "zoxide"
      "alias-finder" 
      "eza"
      "direnv" ];
      theme = "robbyrussell";
    };
  };

  programs.zoxide = {

    enable = true;
    enableZshIntegration = true;

    options = [
      "--cmd cd"
    ];

  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;

    defaultOptions = [ "--ansi" "--border=double"];
  };
#programs.eza.enable = true;
#programs.eza.enableNushellIntegration = true;
#programs.eza.enableZshIntegration = true;
}



