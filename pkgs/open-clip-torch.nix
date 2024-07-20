{ lib
, python3Packages
, fetchFromGitHub
,
}:
python3Packages.buildPythonPackage rec {
  pname = "open-clip";
  version = "2.23.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mlfoundations";
    repo = "open_clip";
    rev = "v${version}";
    hash = "sha256-Txm47Tc4KMbz1i2mROT+IYbgS1Y0yHK80xY0YldgBFQ=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3Packages; [
    ftfy
    huggingface-hub
    protobuf
    regex
    sentencepiece
    timm
    torch
    torchvision
    tqdm
  ];

  pythonImportsCheck = [ "open_clip" ];

  meta = with lib; {
    description = "An open source implementation of CLIP";
    homepage = "https://github.com/mlfoundations/open_clip";
    license = licenses.mit;
  };
}
