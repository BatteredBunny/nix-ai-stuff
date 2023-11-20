{
  python3Packages,
  fetchFromGitHub,
  pkgs,
}: let
  nvidia = pkgs.callPackage ../nvidia.nix {};
in
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

    propagatedBuildInputs = with python3Packages; [
      torch
      pandas
      fastparquet
      safetensors
      sentencepiece
      pygments
      websockets
      regex
    ];

    pythonImportsCheck = ["exllamav2"];
  }
