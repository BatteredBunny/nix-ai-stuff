{ lib
, fetchPypi
, python3Packages
, diffusers ? python3Packages.diffusers
,
}:
python3Packages.buildPythonPackage rec {
  pname = "lycoris-lora";
  version = "2.0.2";
  pyproject = true;

  src = fetchPypi {
    pname = "lycoris_lora";
    inherit version;
    hash = "sha256-fkR0JPDJJK2sxn9QiYUjqzymQvi/kiqpcG+7rez8+4M=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    toml
    einops
    diffusers
    safetensors
    torch
    transformers
  ];

  pythonImportsCheck = [ "lycoris" ];

  meta = with lib; {
    description = "Lora beYond Conventional methods, Other Rank adaptation Implementations for Stable diffusion";
    homepage = "https://github.com/KohakuBlueleaf/LyCORIS";
    license = licenses.asl20;
  };
}
