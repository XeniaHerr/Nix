{lib,
 rustPlatform,
 fetchFromGitHub,
 cargo,
 rustc,
 pkg-config,
openssl, ...}:

rustPlatform.buildRustPackage rec {
  pname = "ankify";
  version = "v0.1.1";

  src = fetchFromGitHub {
    owner = "nvlang";
    repo = "ankify";
    rev = version;
    hash = "sha256-YFsujtM8aQl3rQsHYilOBlHmVyhBcief+SX+G3aiRws=";

  };

  nativeBuildInputs = [
    cargo
    rustc
    pkg-config
  ];
buildInputs = [
  openssl

];

  cargoHash = "sha256-Qg7M057i4n79C2MFkOAyGxbLLccFEZmOyc0EN/YHkLk";
  doCheck = false;

  meta = {
    description = "Convert typ files to anki cards";
    licenses = lib.licences.mit;
    maintainers = [ ];

  };
  }
