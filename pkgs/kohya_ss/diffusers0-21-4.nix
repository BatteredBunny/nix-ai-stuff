{
  python3Packages,
  fetchFromGitHub,
  lib,
  xformers-cuda,
}:
python3Packages.buildPythonPackage rec {
  pname = "diffusers";
  version = "0.21.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-nyKZVnthADMFA2DVlCPLYJUf0R3fV++OzGhjHDJnMI0=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3Packages; [
    packaging
    huggingface-hub
    transformers
    pillow
    xformers-cuda
  ];

  pythonImportsCheck = [pname];

  meta = with lib; {
    description = "Diffusers: State-of-the-art diffusion models for image and audio generation in PyTorch";
    homepage = "https://github.com/huggingface/diffusers";
    license = licenses.asl20;
  };
}
