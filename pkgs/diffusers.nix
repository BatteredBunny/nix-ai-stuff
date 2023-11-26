{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonPackage rec {
  pname = "diffusers";
  version = "0.23.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "diffusers";
    rev = "v${version}";
    hash = "sha256-KRdOA4TIfneKXUBvRb1a193/JZXM5Br1MxogiK+CFss=";
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
  ];

  pythonImportsCheck = [ "diffusers" ];

  meta = with lib; {
    description = "Diffusers: State-of-the-art diffusion models for image and audio generation in PyTorch";
    homepage = "https://github.com/huggingface/diffusers";
    license = licenses.asl20;
  };
}
