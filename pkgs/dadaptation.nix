{ lib
, python3Packages
, fetchPypi
,
}:
python3Packages.buildPythonPackage rec {
  pname = "dadaptation";
  version = "3.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qkFZyZ8xtBA6Uwz556G3dpEuYcMX/2hLJxdR1NGDLfc=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    torch
  ];

  pythonImportsCheck = [ "dadaptation" ];

  meta = with lib; {
    description = "Learning Rate Free Learning for Adam, SGD and AdaGrad";
    homepage = "https://github.com/facebookresearch/dadaptation";
    license = licenses.mit;
  };
}
