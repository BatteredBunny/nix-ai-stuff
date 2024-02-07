{
  stdenv,
  fetchurl,
  undmg,
  lib,
  nix-update-script,
}:
stdenv.mkDerivation rec {
  pname = "ava";
  version = "2024-02-05";

  src = fetchurl {
    url = "https://s3.amazonaws.com/www.avapls.com/Ava_${version}.dmg";
    hash = "sha256-gPpl64VrKGxowU1Ytcjp/Jzy5IP7uLvlEjkTNGYof7U=";
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
