{
  appimageTools,
  fetchurl,
}:
appimageTools.wrapType2 {
  pname = "lmstudio";
  version = "0.2.8";

  src = fetchurl {
    url = "https://s3.amazonaws.com/releases.lmstudio.ai/prerelease/LM+Studio-0.2.8-beta-v1.AppImage";
    hash = "sha256-Ha1G9YrLrHBPYHoqOoMhqVr/9AtUQILCuxdp07kWebk=";
  };
}
