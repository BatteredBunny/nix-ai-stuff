{ lib
, rustPlatform
, pkg-config
, protobuf
, oniguruma
, openssl
, stdenv
, darwin
, fetchFromGitHub
,
}:
rustPlatform.buildRustPackage rec {
  pname = "text-generation-inference";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-BKUtBp+U0IYlaFfSTF04+NktfbtymDh1ppPFHp8TqX4=";
  };

  cargoHash = "sha256-y4NOyrWd14NnXr1PUpEn5XGrhJuLfP8WTnB64m0eP1g=";

  nativeBuildInputs = [
    pkg-config
    protobuf
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
