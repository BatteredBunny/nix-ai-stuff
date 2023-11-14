{
  python3Packages,
  fetchPypi,
  python3,
}:
python3Packages.buildPythonPackage rec {
  pname = "gekko";
  version = "1.0.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WNyEdJXBXfhrD1LywBBJ3Ehk+CnUS8VYbJFK8mpKV20=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
  ];
}
