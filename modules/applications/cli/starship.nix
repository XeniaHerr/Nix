{config, pkgs, lib, ...}:

{

  options.host.applications.util.starship.enable = lib.mkEnableOption "starship";


  config = lib.mkIf config.host.applications.util.starship.enable {


    programs.starship = {

      enable = true;



      settings = {
      add_newline = true;

      format = "$directory$git_branch$git_commit$git_state$git_status$nix_shell$direnv$sudo\n$character";

        character = {
          success_symbol = "[❯](bold green) ";
      error_symbol = "[❯](bold red) ";
        };

        sudo = {
          disabled = false;
        };

      };
    };

  };
}
