{ symlinkJoin
, cudaPackages
, pkgs
, cudaCapabilities ? pkgs.cudaPackages.flags.cudaCapabilities
, lib
,
}: {
  BUILD_CUDA_EXT = "1";

  CUDA_HOME = symlinkJoin {
    name = "cuda-redist";
    paths = with cudaPackages; [
      cuda_cudart # cuda_runtime.h
      cuda_nvcc
    ];
  };

  CUDA_VERSION = cudaPackages.cudaMajorMinorVersion;

  preBuild = ''
    export PATH=${pkgs.gcc13Stdenv.cc}/bin:$PATH
    export TORCH_CUDA_ARCH_LIST="${lib.concatStringsSep ";" cudaCapabilities}"
  '';
}
