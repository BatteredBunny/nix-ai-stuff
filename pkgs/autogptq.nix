{ python3Packages
, fetchFromGitHub
, pkgs
, lib
, rouge
,
}:
let
  nvidia = pkgs.callPackage ../nvidia.nix { };
in
python3Packages.buildPythonPackage rec {
  inherit (nvidia) BUILD_CUDA_EXT CUDA_HOME CUDA_VERSION preBuild;

  pname = "auto_gptq";
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PanQiWei";
    repo = "AutoGPTQ";
    rev = "v${version}";
    hash = "sha256-CkTWoLY1PLPHKTquwdpxN6L5jGTokK5BFV2owwoTlQ0=";
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
    accelerate
    datasets
    sentencepiece
    numpy
    rouge
    gekko
    torch
    safetensors
    transformers
    peft
    tqdm
  ];

  pythonImportsCheck = [ "auto_gptq" ];

  meta = with lib; {
    homepage = "https://github.com/PanQiWei/AutoGPTQ";
    description = "An easy-to-use LLMs quantization package";
    changelog = "https://github.com/AutoGPTQ/AutoGPTQ/releases/tag/${src.rev}";
    license = licenses.mit;
  };
}
