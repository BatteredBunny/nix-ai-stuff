{
  python3Packages,
  fetchFromGitHub,
  pkgs,
  lib,
}: let
  nvidia = pkgs.callPackage ../nvidia.nix {};
in
  python3Packages.buildPythonPackage rec {
    inherit (nvidia) BUILD_CUDA_EXT CUDA_HOME CUDA_VERSION preBuild;

    pname = "exllamav2";
    version = "0.0.9";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "turboderp";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-rEKoqaDGv9HTiatseE9Q9wNmX+rV4mB2bNyC0X/3B7k=";
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

    pythonImportsCheck = [pname];

    meta = with lib; {
      homepage = "https://github.com/turboderp/exllamav2";
      description = " A fast inference library for running LLMs locally on modern consumer-class GPUs";
      license = licenses.mit;
    };
  }
