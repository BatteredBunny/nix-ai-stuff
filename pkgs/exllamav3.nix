{ lib
, buildPythonPackage
, fetchFromGitHub
, flash-attn
, python3Packages
,
}:

buildPythonPackage {
  pname = "exllamav3";
  version = "unstable-2025-04-18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "turboderp-org";
    repo = "exllamav3";
    rev = "c44e56c73b2c67eee087c7195c9093520494d3bf";
    hash = "sha256-NEIgBWJTCiwaKoq7R+6mMR7LcQ5enmzLGx64ortcjOo=";
  };

  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  dependencies = with python3Packages; [
    flash-attn
    ninja
    numpy
    rich
    safetensors
    tokenizers
    torch
    typing-extensions
  ];

  pythonImportsCheck = [
    "exllamav3"
  ];

  meta = {
    description = "An optimized quantization and inference library for running LLMs locally on modern consumer-class GPUs";
    homepage = "https://github.com/turboderp-org/exllamav3";
    license = lib.licenses.mit;
  };
}
