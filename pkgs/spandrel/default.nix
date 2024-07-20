{ lib
, python3Packages
, fetchFromGitHub
}:
python3Packages.buildPythonPackage rec {
  pname = "spandrel";
  version = "0.3.4";
  pyproject = true;

  src = fetchFromGitHub
    {
      owner = "chaiNNer-org";
      repo = "spandrel";
      rev = "v${version}";
      hash = "sha256-cwY8gFcaHkyYI0y31WK76FKeq0jhYdbArHhh8Q6c3DE=";
    } + "/libs/spandrel";

  nativeBuildInputs = with python3Packages; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3Packages; [
    torch
    torchvision
    safetensors
    numpy
    einops
    typing-extensions
  ];

  pythonImportsCheck = [ "spandrel" ];

  meta = with lib; {
    description = "Spandrel gives your project support for various PyTorch architectures meant for AI Super-Resolution, restoration, and inpainting. Based on the model support implemented in chaiNNer";
    homepage = "https://github.com/chaiNNer-org/spandrel";
    changelog = "https://github.com/chaiNNer-org/spandrel/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
