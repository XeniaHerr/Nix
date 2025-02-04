{config, pkgs,lib, ... }: {


  options.host.shells.zsh.enable = lib.mkEnableOption "zsh";

  config = lib.mkIf (config.host.settings.shell == "zsh" || config.host.shells.zsh.enable) {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    #    syntaxHighlighting.catppuccin.enable = true;

      shellAliases =
        lib.optionalAttrs (config.host.shells.aliases.enable) config.host.shells.aliases.aliases // { 
      ".." = "cd ..";
      la = "ls -Ahl";
      ff = "fastfetch";
      du = "${pkgs.dust}/bin/dust";
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
        "direnv" ];
      theme = "robbyrussell";
    };
  };

    #TODO: Make these sepereate nix files
  programs.zoxide = {

    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;

    options = [
      "--cmd cd"
    ];

  };


  catppuccin.zsh-syntax-highlighting.enable = true;


  host.applications.util.starship.enable = true;

    host.applications.fzf.enable = true;

  programs.fzf = {
      #    enable = true;
    enableZshIntegration = true;

      #defaultOptions = [ "--ansi" "--border=double"];
  };
  #programs.eza.enable = true;
  #programs.eza.enableNushellIntegration = true;
  #programs.eza.enableZshIntegration = true;
};
}



