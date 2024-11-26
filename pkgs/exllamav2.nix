{ python3Packages
, fetchFromGitHub
, pkgs
, lib
,
}:
let
  nvidia = pkgs.callPackage ../nvidia.nix { };
in
python3Packages.buildPythonPackage rec {
  inherit (nvidia) BUILD_CUDA_EXT CUDA_HOME CUDA_VERSION preBuild;

  pname = "exllamav2";
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "turboderp";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-lAdu062TkQP7tFDkPLnCyjL4Vk4JG7X31Ud03Q1Jqh4=";
  };

  buildInputs = with pkgs; [
    python3Packages.pybind11
    cudatoolkit
  ];

  nativeBuildInputs = with pkgs; [
    which
    ninja
  ];

  dependencies = with python3Packages; [
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
