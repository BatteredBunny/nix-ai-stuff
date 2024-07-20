{ lib
, python3Packages
, fetchPypi
,
}:
python3Packages.buildPythonPackage rec {
  pname = "prodigyopt";
  version = "1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zbvZnoNvpuuQr6SfXrGndg1jShWXbnfj6BFDSavpEKw=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    torch
  ];

  pythonImportsCheck = [ "prodigyopt" ];

  meta = with lib; {
    description = "An Adam-like optimizer for neural networks with adaptive estimation of learning rate";
    homepage = "https://github.com/konstmish/prodigy";
    license = licenses.mit;
  };
}
