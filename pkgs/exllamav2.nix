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
  version = "0.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "turboderp";
    repo = "exllamav2";
    rev = "v${version}";
    hash = "sha256-Nv0jzQshL15wXc6FF1Z/y2NX3xLjKrESyyp9MRdEDxo=";
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
