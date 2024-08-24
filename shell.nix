{configs, pkgs, ... }: {


programs.zsh = {
	enable = true;
	enableCompletion = true;
	autosuggestion.enable = true;
	syntaxHighlighting.enable = true;

	shellAliases = { 
	".." = "cd ..";
	la = "ls -Ahl";
    ff = "fastfetch";
    du = "du -h";
	};

	initExtra = ''
	bindkey '^ ' autosuggest-accept
	'';

	oh-my-zsh = {
	enable = true;
	plugins = [ "git" 
                "ssh"
                "zoxide" ];
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
	};
}
