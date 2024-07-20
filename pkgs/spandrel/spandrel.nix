{ lib
, python3Packages
, version
, github
, meta
}:
python3Packages.buildPythonPackage rec {
  pname = "spandrel";
  inherit version meta;
  pyproject = true;

  src = github + "/libs/spandrel";

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    torch
    torchvision
    safetensors
    numpy
    einops
    typing-extensions
  ];

  pythonImportsCheck = [ "spandrel" ];
}
