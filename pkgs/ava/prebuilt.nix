{
  stdenv,
  fetchurl,
  undmg,
  lib,
}:
stdenv.mkDerivation rec {
  pname = "ava";
  version = "2024-04-21";

  src = fetchurl {
    url = "https://s3.amazonaws.com/www.avapls.com/Ava_${version}.dmg";
    hash = "sha256-f9/fQJ1bmamPsWwR0Kz99Z4CgVzOC5X0gNUnSw4VMuQ=";
  };

  nativeBuildInputs = [undmg];

  sourceRoot = "Ava.app";

  installPhase = ''
    mkdir -p $out/Applications/Ava.app $out/bin
    cp -R . $out/Applications/Ava.app
    ln -s ../Applications/Ava.app/Contents/MacOS/ava $out/bin
  '';

  meta = with lib; {
    homepage = "https://www.avapls.com/";
    description = "A GUI macos LLM program";
    license = licenses.mit;
    platforms = platforms.darwin;
  };
}
