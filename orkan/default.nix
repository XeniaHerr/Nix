{lib, rustPlatform, fetchFromGitHub, cargo, rustc, libxkbcommon, fontconfig, pkg-config, ...}:

rustPlatform.buildRustPackage rec {
  pname = "orkan";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "XeniaHerr";
    repo = "Orkan";
    rev = "master";
    sha256 = "sha256-ANx2dCPdjwhuVM33m0/q9OK+ZyIqQKad6YKR3lQ0S+4=";

  };

  nativeBuildInputs = [
    cargo
    rustc
    pkg-config
  ];

  buildInputs = [
    libxkbcommon
    fontconfig
  ];

  #  buildPhase = ''
  #  export LD_LIBRARY_PATH=${lib.makeLibraryPath [ libxkbcommon fontconfig ]};
  #  cargo build --release
  # '';

  cargoHash = "sha256-IkUDjb46aE3NQmYYaohMxZEnMQaQSyA0sdbKNziilC0=";

  meta = {
    description = "Wayland Programm launcher and Selector similar to dmenu";
    license = lib.licenses.mit;
    maintainers = [ ];

  };
  }
