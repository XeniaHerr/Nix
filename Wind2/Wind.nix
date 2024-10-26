{config, lib, pkgs, ...}:



#This is my custom wind

let
  cfg = config.xsession.windowManager.Wind;

  stringopt = name:  lib.mkOption {
    type = lib.types.str;

    description = " The name is ${name}";


    default = "";
  };

  stringoptwithdefault = name:  def: lib.mkOption {
    type = lib.types.str;

    description = " The name is ${name}";


    default = def;
  };

  liststringopt = name: lib.mkOption {

    type = lib.types.listOf (lib.types.str);

    description = " List of ${name}";
  };


  argtostring = arg: if (builtins.isInt arg) then builtins.toString arg else arg;

  renderStringList = name: input:  lib.concatStringsSep " " [ "${name}:" "[" "${lib.concatStringsSep ", "  input }" "]"];

  renderStringOpt = name: input: lib.concatStringsSep " " [ "${name}:" input];

  renderIntValue = name: input: "${name}: ${builtins.toString input}";




  #renderSingleKey = singlekey: lib.concatStringsSep "\n  " ["- Key: ${singlekey.key}" "${renderStringList "Action" ${singlekey.action}}" ];

  renderSingleKey = singlekey: ''
    - Key: ${singlekey.key}
      Action: ${singlekey.action}
      ${renderStringList "Modifiers" singlekey.modifiers}
      ${ if builtins.isNull singlekey.argument then
      ""
    else
      "argument: ${ argtostring singlekey.argument}"
  }
  '';

  renderKeys =  allkeys: lib.concatStringsSep "\n" ([ "Keys:"] ++ lib.map (k: renderSingleKey k) allkeys);


in
  {

    options = {

      xsession.windowManager.Wind = {


        enable = lib.mkEnableOption "Wind2 Window Manager";

        package = lib.mkOption {
          type = lib.types.package;
          default =  pkgs.callPackage ./default.nix {} ;
          description = "My custom Window manager Package";
        };

        config = {

          Keys = lib.mkOption {

            type = lib.types.listOf (lib.types.submodule {
      options = {

        key = stringopt "key";

        action = stringopt "action";

        modifiers = liststringopt "modifiers";

        argument = lib.mkOption {
          type = lib.types.nullOr (lib.types.oneOf [ lib.types.str lib.types.int ]);

          default = builtins.null;
        };


      };
    }
    );

            default = [
              {
                key = "f";

                action = "spawn";

                modifiers = ["Mod" "Shift"];
              }
            ];

            description = ''
            The Keys that you want to map to specific actions. It is advised
            that you use them only in combination with modifiers and that 
            you always map a way to exit or spawn a Terminal.
            '';
          };


          WindowGap = lib.mkOption {

            type = lib.types.int;

            default = 0;

            description = ''
            Gap between windows
            '';
          };

          BorderWidth = lib.mkOption {

            type = lib.types.int;

            default = 2;

            description = ''
            Thickness of the Border
            '';
          };

          TopicNames = lib.mkOption {

            type = lib.types.listOf lib.types.str;


            default = [ "First" "Second" "Third"];

            description = ''
            List of Virtual Workspaces (Topics)
            '' ;
          };

          Modifier = lib.mkOption {

            type = lib.types.str;

            default = "Mod4";

            description = ''
            Set the Modifier once and reference it later with Mod
            '';
          };

          ActiveColor = stringoptwithdefault "ActiveColor" "blue";
          PassiveColor = stringoptwithdefault "PassiveColor" "grey";
          UrgentColor = stringoptwithdefault "UrgentColor" "red";


        };
      };

    };

    config = lib.mkIf cfg.enable {

      home.packages = [cfg.package];

      xsession.windowManager.command = "${cfg.package}/bin/Wind2";

xdg.configFile."Wind2/Wind2.yaml".source = 
pkgs.writeText "Wind" ''
#This config was generated by home-manager.
#Only edit under own discretions.

${renderStringList "TopicNames" cfg.config.TopicNames}

${renderIntValue "borderwidth" cfg.config.BorderWidth}

${renderIntValue "windowgap" cfg.config.WindowGap}
#Colors for Window Borders
${renderStringOpt "ActiveColor" cfg.config.ActiveColor }
${renderStringOpt "PassiveColor" cfg.config.PassiveColor }
${renderStringOpt "UrgentColor" cfg.config.UrgentColor }

Modifier: ${cfg.config.Modifier}

${renderKeys cfg.config.Keys}



'';
    };

  }
