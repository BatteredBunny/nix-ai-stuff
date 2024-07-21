{ lib
, python3Packages
, fetchFromGitHub
, symlinkJoin
, cudaPackages
, pkgs
}:
let
  nvidia = pkgs.callPackage ../nvidia.nix { };
in
python3Packages.buildPythonPackage rec {
  inherit (nvidia) BUILD_CUDA_EXT CUDA_VERSION preBuild;
  pname = "flash-attention";
  version = "2.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Dao-AILab";
    repo = "flash-attention";
    rev = "v${version}";
    hash = "sha256-7wCB8EGL9Ioqq38+UHINQuwyFbnJkk7CXfujoKPdPl8=";
    fetchSubmodules = true;
  };

  build-tools = with python3Packages; [
    setuptools
    wheel
  ];

  nativeBuildInputs = with pkgs; [
    git
    which
    ninja
  ];

  CUDA_HOME = symlinkJoin {
    name = "cuda-redist";
    paths = buildInputs;
  };

  buildInputs = with cudaPackages; [
    cuda_cudart # cuda_runtime_api.h
    libcusparse # cusparse.h
    cuda_cccl # nv/target
    libcublas # cublas_v2.h
    libcusolver # cusolverDn.h
    libcurand # curand_kernel.h
    cuda_nvcc
  ];

  dependencies = with python3Packages; [
    torch
    psutil
    ninja
    einops
  ];

  pythonImportsCheck = [ "flash_attn" ];

  meta = with lib; {
    description = "Fast and memory-efficient exact attention";
    homepage = "https://github.com/Dao-AILab/flash-attention";
    license = licenses.bsd3;
  };
}
