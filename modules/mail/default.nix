{config, pkgs, lib, ...}:
let
  cfg = config.feature.mail;
in
with lib;
{


  options.host.feature.mail = {

    enable = mkEnableOption "Email functionality";


  };



  config = mkIf cfg.enable {

    home.accounts.email = {

      accounts = {

        xenia_gmail = {
          primary = true;

          flavor = "gmail.com";

          address = "xeniaherr@gmail.com";

          realName = "Xenia Herr";
          userName = "Xenia Herr";

          passwordCommand = "cat ${config.sops.secrets."passwords/Mediumpassword".path}";

        };

      };

    };


  };
}
