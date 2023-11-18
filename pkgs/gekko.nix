{
  python3Packages,
  fetchPypi,
  lib,
}:
python3Packages.buildPythonPackage rec {
  pname = "gekko";
  version = "1.0.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WNyEdJXBXfhrD1LywBBJ3Ehk+CnUS8VYbJFK8mpKV20=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3Packages; [
    numpy
  ];

  pythonImportsCheck = ["gekko"];

  meta = with lib; {
    homepage = "https://github.com/BYU-PRISM/GEKKO";
    description = "Machine learning and optimization for dynamic systems";
    license = licenses.mit;
  };
}
