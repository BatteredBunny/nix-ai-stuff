{
  python3Packages,
  symlinkJoin,
  cudaPackages,
  fetchFromGitHub,
  pkgs,
  gekko,
}:
python3Packages.buildPythonPackage rec {
  pname = "auto_gptq";
  version = "0.5.1";
  pyproject = true;

  BUILD_CUDA_EXT = "1";

  CUDA_HOME = symlinkJoin {
    name = "cuda-redist";
    paths = with cudaPackages; [
      cuda_cudart # cuda_runtime.h
      cuda_nvcc
    ];
  };

  CUDA_VERSION = cudaPackages.cudaVersion;

  src = fetchFromGitHub {
    owner = "PanQiWei";
    repo = "AutoGPTQ";
    rev = "v${version}";
    hash = "sha256-eZJRapxfJaJ6IdvPUhJnlJqvTpctFTGY05jVAmTgrDc=";
  };

  buildInputs = with pkgs; [
    python3Packages.pybind11
    cudatoolkit
  ];

  preBuild = ''
    export PATH=${pkgs.gcc11Stdenv.cc}/bin:$PATH
    export TORCH_CUDA_ARCH_LIST="8.9"
  '';

  nativeBuildInputs = with pkgs; [
    which
    ninja
  ];

  propagatedBuildInputs = [
    python3Packages.torch
    python3Packages.pandas
    python3Packages.packaging
    python3Packages.accelerate
    python3Packages.transformers
    python3Packages.datasets
    python3Packages.peft
    gekko
  ];

  pythonImportsCheck = ["auto_gptq"];
}
