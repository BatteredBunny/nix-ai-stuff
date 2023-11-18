{
  lib,
  python3Packages,
  fetchPypi,
}:
python3Packages.buildPythonPackage rec {
  pname = "tensor_parallel";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Wcb9iUvtxYZSyHPeSvJdAkvyhAGv8yTVAVHorIVZnTc=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    python3Packages.torch
    python3Packages.transformers
  ];

  passthru.optional-dependencies = {
    dev = with python3Packages; [
      accelerate
      black
      einops
      isort
      peft
      psutil
      pytest
      pytest-asyncio
      pytest-forked
    ];
  };

  pythonImportsCheck = ["tensor_parallel"];

  meta = with lib; {
    description = "Automatically shard your large model between multiple GPUs, works without torch.distributed";
    homepage = "https://github.com/BlackSamorez/tensor_parallel";
    license = licenses.mit;
  };
}
