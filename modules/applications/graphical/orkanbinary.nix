{lib,
stdenv,
fetchurl,
libxkbcommon,
fontconfig,
autoPatchelfHook,
...}:
stdenv.mkDerivation {

  pname = "Orkan";
  version = "v0.1.1";

  src = fetchurl {
    url = "https://github.com/XeniaHerr/Orkan/releases/download/v0.1.1/Orkan";
    hash = "sha256-818IajCsL/7EgcgzoyOmHiHyJemyf5RIgZtoXSbDM1M=";
  };

  phases = [ "installPhase" "patchPhase"];

  buildInputs = [
    libxkbcommon
    fontconfig
  ];

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/Orkan
    chmod +x $out/bin/Orkan
  '';
}
