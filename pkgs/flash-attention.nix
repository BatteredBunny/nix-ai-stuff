{ lib
, python3Packages
, fetchFromGitHub
, symlinkJoin
, pkgs
}:
let
  inherit (python3Packages.torch) cudaCapabilities cudaPackages;
  inherit (cudaPackages) backendStdenv;

  nvidia = pkgs.callPackage ../nvidia.nix { };
in
python3Packages.buildPythonPackage rec {
  inherit (nvidia) BUILD_CUDA_EXT CUDA_VERSION preBuild;
  pname = "flash-attn";
  version = "2.7.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Dao-AILab";
    repo = "flash-attention";
    rev = "v${version}";
    hash = "sha256-dFJplpZojvtV1wbqNY0SGPw2c8kxMOF+qFo8I9asDJs=";
    fetchSubmodules = true;
  };

  preConfigure = ''
    export CC=${lib.getExe' backendStdenv.cc "cc"}
    export CXX=${lib.getExe' backendStdenv.cc "c++"}
    export TORCH_CUDA_ARCH_LIST="${lib.concatStringsSep ";" cudaCapabilities}"
    export FORCE_CUDA=1
  '';

  build-tools = with python3Packages; [
    setuptools
    wheel
  ];

  nativeBuildInputs = with pkgs; [
    git
    which
    ninja
  ];

  env.CUDA_HOME = symlinkJoin {
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
