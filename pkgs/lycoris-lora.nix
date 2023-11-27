{
  lib,
  fetchPypi,
  diffusers,
  python3Packages,
}:
python3Packages.buildPythonPackage rec {
  pname = "lycoris-lora";
  version = "1.9.0";
  pyproject = true;

  src = fetchPypi {
    pname = "lycoris_lora";
    inherit version;
    hash = "sha256-pPPlkQYGniN/3mprhWAJ3PNP9hpnZnYvlZiETKyrVbI=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3Packages; [
    diffusers
    safetensors
    torch
    transformers
  ];

  # pythonImportsCheck = ["lycoris-lora"];

  meta = with lib; {
    description = "Lora beYond Conventional methods, Other Rank adaptation Implementations for Stable diffusion";
    homepage = "https://github.com/KohakuBlueleaf/LyCORIS";
    license = licenses.asl20;
  };
}
