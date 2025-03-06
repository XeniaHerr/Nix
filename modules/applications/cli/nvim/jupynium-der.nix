{config, ... }: let helpers = config.lib.nixvim;
  fooOption = helpers.mkRaw "print('ConfigTest') ";
in 
  helpers.plugins.mkNeovimPlugin {
  name = "jupynium.nix";
  url = "https://github.com/kiyoon/jupynium.nvim";

  callSetup = true;
    maintainers = [ config.lib.maintainers.elysasrc];

}

  
