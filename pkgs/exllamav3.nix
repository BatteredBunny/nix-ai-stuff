{ lib
, fetchFromGitHub
, flash-attn
, python3Packages
, kbnf
, formatron
, pkgs
, symlinkJoin
,
}:
let
  inherit (python3Packages.torch) cudaPackages;
  inherit (cudaPackages) backendStdenv;
in
python3Packages.buildPythonPackage rec{
  pname = "exllamav3";
  version = "0.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "turboderp-org";
    repo = "exllamav3";
    rev = "v${version}";
    hash = "sha256-+9aduBeoQOkEIw5XMQgzcWM+TAUHrHgWO1EQdoHCyhE=";
  };

  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  buildInputs = with pkgs; [
    cudatoolkit
  ];

  dependencies = with python3Packages; [
    torch
    flash-attn
    ninja
    tokenizers
    numpy
    rich
    typing-extensions
    safetensors
    ninja

    pillow
    pyyaml
    marisa-trie
    kbnf
    formatron
  ];

  # TODO: remove TORCH_CUDA_ARCH_LIST hardcoding
  preConfigure = ''
    export CC=${lib.getExe' backendStdenv.cc "cc"}
    export CXX=${lib.getExe' backendStdenv.cc "c++"}
    export TORCH_CUDA_ARCH_LIST="8.9+PTX;8.9"
    export FORCE_CUDA=1
  '';

  env.CUDA_HOME = symlinkJoin {
    name = "cuda-redist";
    paths = with cudaPackages; [
      cuda_cudart # cuda_runtime.h
      cuda_nvcc
    ];
  };

  pythonImportsCheck = [ "exllamav3" ];

  meta = {
    description = "An optimized quantization and inference library for running LLMs locally on modern consumer-class GPUs";
    homepage = "https://github.com/turboderp-org/exllamav3";
    license = lib.licenses.mit;
  };
}
