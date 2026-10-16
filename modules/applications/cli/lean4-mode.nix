{fetchFromGitHub,
  melpaBuild,...
}: melpaBuild {

  pname = "lean4-mode";
  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo  ="lean4-mode";
    hash = "sha256-6XFcyqSTx1CwNWqQvIc25cuQMwh3YXnbgr5cDiOCxBk=";
    rev = "1388f9d1429e38a39ab913c6daae55f6ce799479";

  };


  version = "0-unstable-2026-04-10";

}


