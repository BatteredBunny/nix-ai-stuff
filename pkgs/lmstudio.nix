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
        url = "https://releases.lmstudio.ai/linux/0.2.17/test/LM_Studio-0.2.17-preview-6.AppImage";
        hash = "sha256-bag0lb+2TUbzF1EsvkMOcbgRnar2/9Aym2SdcJja1bo=";
      };
      aarch64-darwin = fetchurl {
        url = "https://releases.lmstudio.ai/mac/arm64/0.2.17/latest/LM-Studio-0.2.17-arm64.dmg";
        hash = "sha256-ktPEfFeqlIXrxO5YG4mJCBTJWt2IZthdV+6jsovm0jM=";
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
  version = "0.2.17";

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
