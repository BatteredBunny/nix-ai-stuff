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
  version = "unstable-2025-08-26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "theroyallab";
    repo = "tabbyAPI";
    rev = "1d3a3087090d8522ccc5856a7a738a8a93aa2c61";
    hash = "sha256-OqV6uNy9xJUao6Y5z9+E/GlE8ATIGBFXr9AnQI48pJ8=";
  };

  build-system = with python3Packages; [
    packaging
    setuptools
    wheel
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
