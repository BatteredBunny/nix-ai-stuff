{
  appimageTools,
  fetchurl,
  lib,
}:
appimageTools.wrapType2 rec {
  pname = "lmstudio";
  version = "0.2.8";

  src = fetchurl {
    url = "https://s3.amazonaws.com/releases.lmstudio.ai/prerelease/LM+Studio-0.2.8-beta-v1.AppImage";
    hash = "sha256-Ha1G9YrLrHBPYHoqOoMhqVr/9AtUQILCuxdp07kWebk=";
  };

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}
  '';

  meta = with lib; {
    description = "A GUI tool to run LLMs";
    homepage = "https://lmstudio.ai/";
    platforms = platforms.linux;
    mainProgram = pname;
  };
}
