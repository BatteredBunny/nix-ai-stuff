{ lib
, fetchPypi
, python3Packages
}:

python3Packages.buildPythonPackage rec {
  pname = "rouge";
  version = "1.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ErSDRspH1rzzxFBh8xVFK5zOwGIO6JXshbfvw9VKrjQ=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3Packages; [
    six
  ];

  pythonImportsCheck = [ "rouge" ];

  meta = with lib; {
    description = "Full Python ROUGE Score Implementation (not a wrapper";
    homepage = "https://pypi.org/project/rouge/";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
