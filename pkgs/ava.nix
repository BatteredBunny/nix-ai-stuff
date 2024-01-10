{
  stdenv,
  fetchurl,
  undmg,
  lib,
  nix-update-script,
}:
stdenv.mkDerivation rec {
  pname = "ava";
  version = "2023-12-05";

  src = fetchurl {
    url = "https://s3.amazonaws.com/www.avapls.com/Ava_${version}.dmg";
    hash = "sha256-Pr5I/Tigm43oqFg55Ygxe/2QLxm9a0wWp+uovfm6uhE=";
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
    license = licenses.unfree;
    platforms = platforms.darwin;
    mainProgram = pname;
  };
}
