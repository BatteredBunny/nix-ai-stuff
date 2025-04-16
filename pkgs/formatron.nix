{ lib
, python3Packages
, fetchFromGitHub
, exllamav2
, general-sam
, kbnf
,
}:
python3Packages.buildPythonPackage rec {
  pname = "formatron";
  version = "0.4.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Dan-wanna-M";
    repo = "formatron";
    rev = "v${version}";
    hash = "sha256-VXOZTSD9xNB9UaA84T1FrEN3WIYbaieSfwjf7J6P+KA=";
    fetchSubmodules = true;
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    frozendict
    general-sam
    jsonschema
    kbnf
    pydantic
  ];

  optional-dependencies = with python3Packages; {
    exllamav2 = [
      exllamav2
    ];
    rwkv = [
      rwkv
    ];
    transformers = [
      transformers
    ];
    vllm = [
      vllm
    ];
  };

  pythonImportsCheck = [
    "formatron"
  ];

  meta = {
    description = "Formatron empowers everyone to control the format of language models' output with minimal overhead";
    homepage = "https://github.com/Dan-wanna-M/formatron";
    license = lib.licenses.mit;
  };
}
