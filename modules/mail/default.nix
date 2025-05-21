{config, pkgs, lib, ...}:
let
  cfg = config.host.features.mail;
in
with lib;
{


  options.host.features.mail = {

    enable = mkEnableOption "Email functionality";


  };



  config = mkIf cfg.enable {

    home.packages = [
      pkgs.thunderbird
    ];

/*
    programs.thunderbird = {
      enable = true;

      profiles = {
        
      };

    };
    */

    accounts.email = {

      maildirBasePath = "mailbox";
      accounts = {

        xenia_gmail = {
          primary = true;

          flavor = "gmail.com";

          address = "xeniaherr@gmail.com";

          realName = "Xenia Herr";
          userName = "Xenia Herr";

          passwordCommand = "cat ${config.sops.secrets."passwords/gmail".path}";

          thunderbird = {
            enable = true;
          };

        };

        unimail = {
          primary = false;

          address = "kenneth.herr@stud.uni-heidelberg.de";
          realName = "Kenneth Herr";
          userName = "dd272";

          passwordCommand = "cat ${config.sops.secrets."passwords/Unipassword".path}";
          imap = {
            host = "imap.urz.uni-heidelberg.de";
            port = 993;
            tls.enable = true;
          };

          smtp = {
            host = "mail.urz.uni-heidelberg.de";
            port = 587;
            tls.enable = false;

          };

          thunderbird = {
            enable = true;
          };

        };

      };

    };


    services.mbsync.enable = true;

    programs.mbsync.enable = true;
    programs.neomutt = { enable = true; 
    vimKeys = true;
      editor = "nvim";
      settings = {
        folder = "~/mailbox/";
      };
    };


  };
}
