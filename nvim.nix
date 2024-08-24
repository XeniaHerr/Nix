{config, pkgs, ... }: {

programs.neovim = {

enable = true;

viAlias = true;

vimAlias = true;

#extraConfig = pkgs.lib.fileContents ../nvim/init.lua;



};

  home.file."${config.xdg.configHome}/nvim/init.lua".source = ../nvim/init.lua;
}
