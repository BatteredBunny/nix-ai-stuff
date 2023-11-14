{
  appimageTools,
  fetchurl,
  lib,
  stdenv,
  undmg,
}: let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  src =
    {
      x86_64-linux = fetchurl {
        url = "https://s3.amazonaws.com/releases.lmstudio.ai/prerelease/LM+Studio-0.2.8-beta-v1.AppImage";
        hash = "sha256-Ha1G9YrLrHBPYHoqOoMhqVr/9AtUQILCuxdp07kWebk=";
      };
      aarch64-darwin = fetchurl {
        url = "https://s3.amazonaws.com/releases.lmstudio.ai/0.2.8/LM+Studio-0.2.8-arm64.dmg";
        hash = "sha256-aLINH3eRv0kGH+7B1BzN/61/wChdDlwIbrFfTGbMOrI=";
      };
    }
    .${system}
    or throwSystem;

  meta = with lib; {
    description = "A GUI tool to run LLMs";
    homepage = "https://lmstudio.ai/";
    license = licenses.unfree;
    platforms = ["x86_64-linux" "aarch64-darwin"];
    mainProgram = pname;
  };

  pname = "lmstudio";
  version = "0.2.8";

  linux = appimageTools.wrapType2 rec {
    inherit pname version src meta;

    extraInstallCommands = ''
      mv $out/bin/${pname}-${version} $out/bin/${pname}
    '';
  };

  darwin = stdenv.mkDerivation {
    inherit pname version src meta;

    nativeBuildInputs = [undmg];

    sourceRoot = "LM Studio.app";

    installPhase = ''
      mkdir -p $out/Applications/LM\ Studio.app
      cp -R . $out/Applications/LM\ Studio.app
    '';
  };
in
  if stdenv.isDarwin
  then darwin
  else linux
