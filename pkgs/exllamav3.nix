{ lib
, fetchFromGitHub
, python3Packages
, pkgs
, symlinkJoin
, cudaSupport ? python3Packages.torch.cudaSupport
, cudaPackages ? python3Packages.torch.cudaPackages
,
}: python3Packages.buildPythonPackage rec{
  pname = "exllamav3";
  version = "0.0.18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "turboderp-org";
    repo = "exllamav3";
    rev = "v${version}";
    hash = "sha256-E0/RNSmxj+X5PgsWi5LVcUsiTl73ladIYo00SJTF13g=";
  };

  nativeBuildInputs = with pkgs.python3Packages; [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "pydantic" # Wants 2.11.0 but nixpkgs has 2.11.7
  ];

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
    pydantic
    formatron
  ];

  stdenv = cudaPackages.backendStdenv;

  env = {
    CUDA_HOME = symlinkJoin {
      name = "cuda-redist";
      paths = with cudaPackages; [
        cuda_cudart # cuda_runtime.h
        cuda_nvcc
      ];
    };
    TORCH_CUDA_ARCH_LIST = "8.9+PTX;8.9";
  };

  pythonImportsCheck = [ "exllamav3" ];

  meta = {
    description = "Quantization and inference library for running LLMs locally on modern consumer-class GPUs";
    homepage = "https://github.com/turboderp-org/exllamav3";
    changelog = "https://github.com/turboderp-org/exllamav3/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    platforms = with lib.platforms; windows ++ linux;
    broken = !cudaSupport;
  };
}
