{
  config,
  cudaPackages,
  fetchFromGitHub,
  lib,
  symlinkJoin,
  pkgs,
  python3Packages,
}: let
  cudaSupport = config.cudaSupport or false;

  # Build-time dependencies
  cuda-native-redist = symlinkJoin {
    name = "cuda-native-redist-${cudaPackages.cudaVersion}";
    paths = with cudaPackages; [
      cuda_cccl #include <thrust/*>
      cuda_cudart #include <cuda_runtime.h>
      cuda_nvcc
      libcublas #include <cublas_v2.h>
      libcurand #include <curand_kernel.h>
      libcusolver #include <cusolverDn.h>
      libcusparse #include <cusparse.h>
    ];
  };
in
  # slightly modified version of https://github.com/NixOS/nixpkgs/pull/234557
  python3Packages.buildPythonPackage rec {
    pname = "xformers";
    version = "0.0.22.post7";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "facebookresearch";
      repo = pname;
      rev = "v${version}";
      fetchSubmodules = true;
      leaveDotGit = true;
      hash = "sha256-fknZ5QoB4hop0NprxiQ396oh6BK9IAnkeV92CqK2zgc=";
    };

    nativeBuildInputs = with pkgs; [
      cuda-native-redist
      git
      ninja
      which
    ];

    propagatedBuildInputs = with python3Packages; [
      numpy
      torch
    ];

    postPatch = ''
      substituteInPlace xformers/__init__.py \
        --replace "_is_functorch_available: bool = False" "_is_functorch_available: bool = True"
    '';

    preBuild = ''
      export XFORMERS_BUILD_TYPE=Release
      export TORCH_CUDA_ARCH_LIST="${lib.strings.concatStringsSep ";" python3Packages.torch.cudaCapabilities}"
      export CC="${cudaPackages.backendStdenv.cc}/bin/cc"
      export CXX="${cudaPackages.backendStdenv.cc}/bin/c++"
    '';

    # Note: Tests require ragged_inference, which is in the experimental module and is not built
    # by default.
    doCheck = false;
    pythonImportsCheck = [pname];

    passthru = {
      inherit cudaSupport cudaPackages;
      cudaCapabilities = lib.lists.optionals cudaSupport python3Packages.torch.cudaCapabilities;
    };

    meta = with lib; {
      description = "Hackable and optimized Transformers building blocks, supporting a composable construction";
      homepage = "https://github.com/facebookresearch/xformers";
      license = licenses.bsd3;
      platforms = platforms.linux;
      broken = cudaSupport != python3Packages.torch.cudaSupport;
    };
  }
