{
  stdenv,
  fetchurl,
  undmg,
  lib,
  nix-update-script,
}:
stdenv.mkDerivation rec {
  pname = "ava";
  version = "2023-10-26";

  src = fetchurl {
    url = "https://s3.amazonaws.com/www.avapls.com/Ava_${version}.dmg";
    hash = "sha256-GeG27vwKp2+cTJY4oCO5nlGMStgfTwHyn2TFQKLwmRk=";
  };

  nativeBuildInputs = [undmg];

  sourceRoot = "Ava.app";

  installPhase = ''
    mkdir -p $out/Applications/Ava.app $out/bin
    cp -R . $out/Applications/Ava.app
    ln -s ../Applications/Ava.app/Contents/MacOS/ava $out/bin
  '';

  passthru.updateScript = nix-update-script {};

  meta = with lib; {
    homepage = "https://www.avapls.com/";
    description = "A GUI macos LLM program";
    platforms = platforms.darwin;
    mainProgram = "ava";
  };
}
