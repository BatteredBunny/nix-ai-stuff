{
  python3Packages,
  fetchFromGitHub,
  pkgs,
  nvidia,
}:
python3Packages.buildPythonPackage rec {
  inherit (nvidia) BUILD_CUDA_EXT CUDA_HOME CUDA_VERSION preBuild;

  pname = "exllamav2";
  version = "0.0.8";
  pyproject = true;

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
