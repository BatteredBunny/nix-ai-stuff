{ python3Packages
, fetchFromGitHub
, flash-attn
, pkgs
, lib
,
}:
let
  inherit (python3Packages.torch) cudaCapabilities cudaPackages cudaSupport;
  inherit (cudaPackages) backendStdenv;
in
python3Packages.buildPythonPackage rec {
  pname = "exllamav2";
  version = "0.2.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "turboderp";
    repo = "exllamav2";
    rev = "v${version}";
    hash = "sha256-iaeo4D2I6J0/tDz1Q9kLLU6vHkdVayPhcQQAkYs/fDg=";
  };

  preConfigure = ''
    export CC=${lib.getExe' backendStdenv.cc "cc"}
    export CXX=${lib.getExe' backendStdenv.cc "c++"}
    export TORCH_CUDA_ARCH_LIST="${lib.concatStringsSep ";" cudaCapabilities}"
    export FORCE_CUDA=1
  '';

  buildInputs = with pkgs; [
    python3Packages.pybind11
    cudatoolkit
  ];

  env.CUDA_HOME = lib.optionalString cudaSupport (lib.getDev cudaPackages.cuda_nvcc);

  nativeBuildInputs = with pkgs; [
    which
    ninja
  ];

  postPatch = ''
    substituteInPlace requirements.txt --replace-fail "numpy~=1.26.4" "numpy"
  '';

  dependencies = with python3Packages; [
    flash-attn
    pandas
    fastparquet
    torch
    safetensors
    sentencepiece
    pygments
    websockets
    regex
    numpy
    tokenizers
    rich
    ninja
    pillow
  ];

  pythonImportsCheck = [ "exllamav2" ];

  meta = with lib; {
    homepage = "https://github.com/turboderp/exllamav2";
    description = "A fast inference library for running LLMs locally on modern consumer-class GPUs";
    changelog = "https://github.com/turboderp/exllamav2/releases/tag/${src.rev}";
    license = licenses.mit;
  };
}
