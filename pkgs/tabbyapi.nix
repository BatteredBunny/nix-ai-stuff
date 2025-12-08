{ lib
, fetchFromGitHub
, exllamav2
, exllamav3
, python3Packages
, formatron
, kbnf
,
}:
python3Packages.buildPythonApplication {
  pname = "tabbyapi";
  version = "unstable-2025-11-25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "theroyallab";
    repo = "tabbyAPI";
    rev = "8b6b793bfc4b848986d55340aed1f02e55ff9db8";
    hash = "sha256-+CxTBO8tEXgf2kvKLdlGy2cBg1ilizsWMz72dAVA4os=";
  };

  build-system = with python3Packages; [
    packaging
    setuptools
    wheel
  ];

  nativeBuildInputs = with python3Packages; [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "pydantic" # Wants 2.11.0 but nixpkgs has 2.11.7
  ];

  dependencies = with python3Packages; [
    fastapi # fastapi-slim
    pydantic
    ruamel-yaml
    rich
    uvicorn
    jinja2
    loguru
    sse-starlette
    packaging
    tokenizers
    formatron
    kbnf
    aiofiles
    aiohttp
    async-lru
    huggingface-hub
    psutil
    httptools
    pillow

    numpy
    setuptools

    uvloop # linux and x86_64
    exllamav2
    exllamav3
  ];

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail 'fastapi-slim' 'fastapi'
  '';

  optional-dependencies = with python3Packages; {
    amd = [
      pytorch-triton-rocm
      torch
    ];
    cu118 = [
      torch
    ];
    cu121 = [
      flash-attn
      torch
    ];
    dev = [
      ruff
    ];
    extras = [
      infinity-emb
      sentence-transformers
    ];
  };

  postInstall = ''
    cp *.py $out/lib/python3*/site-packages/
    cp -r {common,endpoints,backends,templates} $out/lib/python3*/site-packages/
  '';

  postFixup = ''
    chmod +x $out/lib/python3*/site-packages/main.py
    sed -i -e '1i#!/usr/bin/python' $out/lib/python3*/site-packages/main.py
    patchShebangs $out/lib/python3*/site-packages/main.py

    mkdir $out/bin
    ln -s $out/lib/python3*/site-packages/main.py $out/bin/tabbyapi

    wrapProgram "$out/bin/tabbyapi" \
      --prefix PYTHONPATH : "$PYTHONPATH" \
  '';

  meta = {
    description = "An OAI compatible exllamav2 API that's both lightweight and fast";
    homepage = "https://github.com/theroyallab/tabbyAPI";
    license = lib.licenses.agpl3Only;
    mainProgram = "tabbyapi";
  };
}
