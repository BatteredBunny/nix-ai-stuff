{ lib
, python3Packages
, fetchFromGitHub
, rustPlatform
, pkgs
,
}:

python3Packages.buildPythonPackage rec {
  pname = "kbnf";
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Dan-wanna-M";
    repo = "kbnf";
    rev = "v${version}-python";
    hash = "sha256-reefuqS0eExky9qtxBTqwxnZgK8AWFfkrN+VL/lFLyg=";
  };

  # Manually unarchived from tarball from pypi
  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  cargoDeps = rustPlatform.importCargoLock { lockFile = ./Cargo.lock; };

  build-system = with pkgs;[
    maturin
  ];

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  dependencies = with python3Packages; [
    numpy
  ];

  optional-dependencies = with python3Packages; {
    efficient_logits_mask = [
      triton
    ];
    torch = [
      torch
    ];
  };

  pythonImportsCheck = [
    "kbnf"
  ];

  meta = {
    description = "A fast constrained decoding engine based on context free grammar";
    homepage = "https://pypi.org/project/kbnf/";
    license = with lib.licenses; [ asl20 mit ];
  };
}
