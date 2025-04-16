{ lib
, python3Packages
, fetchPypi
, rustPlatform
, pkgs
,
}:

python3Packages.buildPythonPackage rec {
  pname = "kbnf";
  version = "0.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+CPHljZOLd0zPH+/N8KNhnpCRKRZuk6r6qx1X4sa2rk=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-YZexO7/J9CBNVO1oVwUq/5Q7k5LyG6oDfidjUKiFGMg=";
  };

  build-system = with pkgs; [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  dependencies = with python3Packages; [
    numpy
  ];

  optional-dependencies = with python3Packages;  {
    torch = [
      torch
    ];
  };

  pythonImportsCheck = [
    "kbnf"
  ];

  meta = {
    description = "A fast constrained decoding engine based on context free grammar";
    homepage = "https://pypi.org/project/kbnf/";
    license = with lib.licenses; [ asl20 mit ];
  };
}
