{fetchgit,
  melpaBuild}:
melpaBuild {
  pname = "nael";

  src = fetchgit {
    url = "https://codeberg.org/mekeor/nael.git";
    hash = "sha256-X3yw0pBgUN71TdPcEPznjq//U5X8P+zctik3nw11RSI=";
    rev = "refs/tags/v0.8.3";
  };
  version = "0-unstable-2026-04-10";

}
