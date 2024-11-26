{ lib
, rustPlatform
, pkg-config
, protobuf
, oniguruma
, openssl
, python3
, stdenv
, darwin
, fetchFromGitHub
,
}:
rustPlatform.buildRustPackage rec {
  pname = "text-generation-inference";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+TX1q1CAhTDIoiJAvauAvDE3uywX4yzdyGBTmacghfc=";
  };

  cargoHash = "sha256-aXFtGEiN71Ly4qJywzpcrW634RB6bYwfI1bTivC6gt0=";

  nativeBuildInputs = [
    pkg-config
    protobuf
    python3
  ];

  buildInputs =
    [
      oniguruma
      openssl
    ]
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      IOKit
      Security
      SystemConfiguration
    ]);

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
