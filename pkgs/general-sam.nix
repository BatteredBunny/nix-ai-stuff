{ lib
, python3Packages
, fetchFromGitHub
, rustPlatform
, pkgs
,
}:

python3Packages.buildPythonPackage rec {
  pname = "general-sam";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ModelTC";
    repo = "general-sam-py";
    rev = "v${version}";
    hash = "sha256-II+pWrV2N3wo7z56VJH7D21QZLBXrx1VbIAcl3AnwwM=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-XMaD6m1Y+CkMSx+Vn7Vc74DJCJ5qU12wr32+PLCiB0U=";
  };

  build-system = with pkgs; [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  optional-dependencies = with python3Packages; {
    test = [
      pytest
    ];
  };

  pythonImportsCheck = [
    "general_sam"
  ];

  meta = {
    description = "Python bindings for general-sam and some utilities";
    homepage = "https://github.com/ModelTC/general-sam-py";
    license = with lib.licenses; [ asl20 mit ];
  };
}
