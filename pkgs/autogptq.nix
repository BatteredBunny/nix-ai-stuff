{
  python3Packages,
  fetchFromGitHub,
  pkgs,
  gekko,
  lib,
}: let
  nvidia = pkgs.callPackage ../nvidia.nix {};
in
  python3Packages.buildPythonPackage rec {
    inherit (nvidia) BUILD_CUDA_EXT CUDA_HOME CUDA_VERSION preBuild;

    pname = "auto_gptq";
    version = "0.5.1";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "PanQiWei";
      repo = "AutoGPTQ";
      rev = "v${version}";
      hash = "sha256-qdpZ5FLAvTwzj2okrqqt43BzjjQ3+Cg6BX+IZkHpgGo=";
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
      packaging
      accelerate
      transformers
      datasets
      peft
      gekko
    ];

    pythonImportsCheck = [pname];

    meta = with lib; {
      homepage = "https://github.com/PanQiWei/AutoGPTQ";
      description = "An easy-to-use LLMs quantization package";
      license = licenses.mit;
    };
  }
