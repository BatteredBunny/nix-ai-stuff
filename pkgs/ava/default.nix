{
  lib,
  stdenv,
  zig_0_12,
  fetchFromGitHub,
  buildNpmPackage,
  callPackage,
  pkgs,
  headless ? stdenv.isLinux,
}: let
  src = fetchFromGitHub {
    owner = "cztomsik";
    repo = "ava";
    rev = "06699ff862c58cbc15c965b58f605b17351ed01c";
    fetchSubmodules = true;
    hash = "sha256-Actn/uJLFYOrA4klQAp0qArdmVuLJfCHOBJRnLVcH8o=";
  };

  version = "2024-04-24";

  web = buildNpmPackage {
    pname = "ava-web";
    inherit src version;

    npmDepsHash = "sha256-B86igaQWHitdBRyA7lGbvrYruhrWsVZGKvWRsJVamdI=";

    nativeBuildInputs = with pkgs; [
      git
    ];

    postPatch = ''
      substituteInPlace package.json \
        --replace "git submodule update --init --recursive" ""
    '';

    buildPhase = ''
      npm run build
    '';

    installPhase = ''
      cp zig-out/app/main.js $out
    '';
  };
in
  stdenv.mkDerivation rec {
    pname = "ava";
    inherit src version;

    nativeBuildInputs = [
      zig_0_12.hook
    ];

    postPatch =
      ''
        ln -s ${callPackage ./deps.nix {}} $ZIG_GLOBAL_CACHE_DIR/p
      ''
      + lib.optionals headless ''
        mkdir -p zig-out/app
        ln -s ${web} zig-out/app/main.js
      '';

    zigBuildFlags =
      [
        "-Dtarget=${stdenv.buildPlatform.qemuArch}-${
          if stdenv.isLinux
          then "linux"
          else "macos"
        }"
      ]
      ++ lib.optionals headless [
        "-Dheadless=true"
      ];

    installPhase = ''
      mkdir -p $out/bin
      cp zig-out/bin/ava_${stdenv.buildPlatform.qemuArch} $out/bin/ava
    '';

    meta = with lib; {
      homepage = "https://www.avapls.com/";
      description = "A GUI macos LLM program";
      license = licenses.mit;
      platforms = platforms.linux ++ platforms.darwin;
      mainProgram = pname;
    };
  }
