#{ pkgs ? import <nixpkgs> {}  , ... }:
{ lib, stdenv ,cmake, yaml-cpp, libX11, libXft, libXinerama, gtest, python311, pkg-config}:


#let 
#  __script = pkgs.writeShellScriptBin "makeWind2" ''
#  #!${pkgs.runtimeShell}
#  cd build;
#  ${pkgs.cmake}/bin/cmake ..;
#  make ..;
#  '';
#in
  stdenv.mkDerivation {

    name = "Wind2";
    src = fetchGit {
      url = "https://github.com/XeniaHerr/Wind2";
#      sha256 = "sha256-bvFHWjTAO7u8uzj8UCqjskLUwavQQw967Bbagx+L1E8=";
#      rev = "3b247ac6bf6fb10291f4847a4711b2b4f280fa92";

    ref = "master";
      
    };

    CFLAGS = [ "-I{$./../include/}" ];

    dontUseCmakeConfigure = true;

    installPhase = ''
    mkdir -p $out/bin
    cp src/Wind2 $out/bin/Wind2
    mkdir -p $out/share/applications
    echo "Currently at"
    pwd
    cd /build/source
    cp install/Wind.desktop $out/share/applications/Wind.desktop
   '';


    buildInputs =  [  yaml-cpp
    libX11
    libXft
    libXinerama
    gtest
    cmake
  ];

  buildPhase = ''
#  cd .build/src/build
  ls
  mkdir -p build
  cd ./build
  cmake ..
  make
  '';

}
