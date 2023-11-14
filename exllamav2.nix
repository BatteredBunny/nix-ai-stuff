{
  python3Packages,
  symlinkJoin,
  cudaPackages,
  fetchFromGitHub,
  pkgs,
}:
python3Packages.buildPythonPackage rec {
  pname = "exllamav2";
  version = "0.0.8";
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
    owner = "turboderp";
    repo = "exllamav2";
    rev = "v${version}";
    hash = "sha256-//AF3ZSeTZHTPRd0s71PbANgQ7f8KViIsCw7Vd2lqaE=";
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
    python3Packages.fastparquet
    python3Packages.safetensors
    python3Packages.sentencepiece
    python3Packages.pygments
    python3Packages.websockets
    python3Packages.regex
  ];

  pythonImportsCheck = ["exllamav2"];
}
