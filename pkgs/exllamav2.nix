{
  python3Packages,
  fetchFromGitHub,
  pkgs,
  lib,
  cudaSupport ? python3Packages.torch.cudaSupport,
  cudaPackages ? python3Packages.torch.cudaPackages,
  cudaCapabilities ? python3Packages.torch.cudaCapabilities,
}:
python3Packages.buildPythonPackage rec {
  pname = "exllamav2";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "turboderp-org";
    repo = "exllamav2";
    rev = "v${version}";
    hash = "sha256-WbpbANenOuy6F0qAKVKAmolHjgRKfPxSVud8FZG1TXw=";
  };

  stdenv = cudaPackages.backendStdenv;

  build-system = with python3Packages; [
    setuptools
  ];

  buildInputs = with pkgs; [
    python3Packages.pybind11
    cudatoolkit
  ];

  env = {
    CUDA_HOME = lib.getDev cudaPackages.cuda_nvcc;
    TORCH_CUDA_ARCH_LIST = lib.concatStringsSep ";" cudaCapabilities;
  };

  nativeBuildInputs = with pkgs; [
    which
    ninja
    python3Packages.pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "numpy" # Wants numpy 1.26.4
  ];

  dependencies = with python3Packages; [
    flash-attn
    pandas
    ninja
    fastparquet
    torch
    safetensors
    pygments
    websockets
    regex
    numpy
    tokenizers
    rich
    pillow
  ];

  pythonImportsCheck = [ "exllamav2" ];

  meta = {
    homepage = "https://github.com/turboderp-org/exllamav2";
    description = "Inference library for running LLMs locally on modern consumer-class GPUs";
    changelog = "https://github.com/turboderp-org/exllamav2/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    platforms = with lib.platforms; windows ++ linux;
    broken = !cudaSupport;
  };
}
