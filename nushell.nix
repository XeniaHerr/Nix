
{config, pkgs, ...}: 

{


  home.packages = [
    pkgs.nushell
    pkgs.nu_scripts
  ];
  programs.nushell = {

  enable = true;


  configFile = {
  text =  ''

  let carapace_completer = { |spans| 
  carapace $spans.0 nushell ...$spans | from json }

  $env.config = {

    show_banner: false,


    hooks: {

    pre_prompt: [{ ||
    if (which direnv | is-empty) {
      return }
      direnv export json | from json | default {} | load-env
      }]
    }

  }

$env.EDITOR = "nvim"
  '';
};


  extraConfig = ''
# Search nixpkgs and provide table output



use ${pkgs.nu_scripts}/share/nu_scripts/modules/background_task/task.nu

export def ns [
    term: string # Search target.
] {

    let info = (
        sysctl -n kernel.arch kernel.ostype
        | lines
        | {arch: ($in.0|str downcase), ostype: ($in.1|str downcase)}
    )

    nix search --json nixpkgs $term
        | from json
        | transpose package description
        | flatten
        | select package description version
        | update package {|row| $row.package | str replace $"legacyPackages.($info.arch)-($info.ostype)." ""}
}
  zoxide init nushell | save -f ~/.zoxide.nu
  '';


  shellAliases = {

    la = "ls -la";

    nv = "nvim";

    cat = "bat";
    ecc = "emacsclient -c";
  };

  plugins = [
    pkgs.nushellPlugins.query
  ];
};


programs.starship = {
  enable = true;

    enableFishIntegration = true;
};


programs.carapace = {
  enable = true;

  enableNushellIntegration = true;

};

}
