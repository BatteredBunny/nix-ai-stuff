{
  python3Packages,
  fetchFromGitHub,
  pkgs,
  gekko,
  nvidia,
}:
python3Packages.buildPythonPackage rec {
  inherit (nvidia) BUILD_CUDA_EXT CUDA_HOME CUDA_VERSION preBuild;

  pname = "auto_gptq";
  version = "0.5.1";
  pyproject = true;

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
