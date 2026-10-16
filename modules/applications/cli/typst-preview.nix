{fetchFromGitHub,
  melpaBuild,
  websocket,
f}:

melpaBuild {
  pname = "typst-preview";
  src = fetchFromGitHub {
    owner = "havarddj";
    repo = "typst-preview.el";
    hash = "sha256-EMmiU/FnSaf6t8sOxnJAGdnl9iQxb/W/otGR99klt4k=";
    tag = "v1.0.0-alpha.2";
  };
  version = "0-unstable-2025-11-07";
  packageRequires = [
    websocket
    
  f ];
}

  
