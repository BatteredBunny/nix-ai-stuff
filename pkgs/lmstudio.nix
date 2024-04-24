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
        url = "https://releases.lmstudio.ai/linux/0.2.20/beta/LM_Studio-0.2.20.AppImage";
        hash = "sha256-T92ZDqGvxJfBkAWsK8EgHdQZnLefK3gDP2vCTL8X+eM=";
      };
      aarch64-darwin = fetchurl {
        url = "https://releases.lmstudio.ai/mac/arm64/0.2.20/latest/LM-Studio-0.2.20-arm64.dmg";
        hash = "sha256-pwe+HRTmTX3KwUa0MaPlz5pAQEs0PtvsF3mJbHdBkIU=";
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
  version = "0.2.20";

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
