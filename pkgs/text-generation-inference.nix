{
  lib,
  rustPlatform,
  pkg-config,
  protobuf,
  oniguruma,
  openssl,
  stdenv,
  darwin,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "text-generation-inference";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-aOo/pop31lf8Wpxp3WNYvRWQVJbkJBWaDo2/oX7bMEk=";
  };

  cargoHash = "sha256-t+wsxxroOroU/JeVo3jrcfpPStZn6GszNBstijc1V2Y=";

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs =
    [
      oniguruma
      openssl
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.IOKit
      darwin.apple_sdk.frameworks.Security
    ];

  doCheck = false;

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  meta = {
    description = "Large Language Model Text Generation Inference";
    homepage = "https://github.com/huggingface/text-generation-inference";
    mainProgram = pname;
  };
}
