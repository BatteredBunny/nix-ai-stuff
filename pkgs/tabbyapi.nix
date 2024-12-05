{ lib
, fetchFromGitHub
, exllamav2
, python3Packages
,
}:

python3Packages.buildPythonApplication {
  pname = "tabbyapi";
  version = "unstable-2024-12-04";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "theroyallab";
    repo = "tabbyAPI";
    rev = "ac85e34356079af017ce4e85a7d431ba4a37bef8";
    hash = "sha256-h7ILPSJB5y8DE8Yf7/YOiOJnMPXN4xfnFwZ+BZiTnyc=";
  };

  build-system = with python3Packages; [
    packaging
    setuptools
    wheel
  ];

  dependencies = with python3Packages; [
    aiofiles
    aiohttp
    async-lru
    fastapi # fastapi-slim
    fastparquet
    httptools
    huggingface-hub
    jinja2
    lm-format-enforcer
    loguru
    numpy
    packaging
    pillow
    psutil
    pydantic
    rich
    ruamel-yaml
    setuptools
    sse-starlette
    tokenizers
    uvicorn
    uvloop
    exllamav2
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
      outlines
      sentence-transformers
    ];
  };

  postInstall = ''
    cp *.py $out/lib/python3*/site-packages/
    cp -r {common,endpoints,backends} $out/lib/python3*/site-packages/
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
    maintainers = with lib.maintainers; [ ];
    mainProgram = "tabbyapi";
  };
}
