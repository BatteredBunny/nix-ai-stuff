{ lib
, python3Packages
, spandrel
, version
, github
, meta
}:
python3Packages.buildPythonPackage rec {
  pname = "spandrel_extra_arches";
  inherit version meta;
  pyproject = true;

  src = github + "/libs/spandrel_extra_arches";

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    spandrel
    torch
    torchvision
    numpy
    einops
    typing-extensions
  ];

  pythonImportsCheck = [ "spandrel_extra_arches" ];
}
