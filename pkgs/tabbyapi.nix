{ lib
, fetchFromGitHub
, exllamav2
, python3Packages
, formatron
, kbnf
,
}:
python3Packages.buildPythonApplication {
  pname = "tabbyapi";
  version = "unstable-2025-04-16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "theroyallab";
    repo = "tabbyAPI";
    rev = "6bb5f8f599d617f94af85e0818c8a841fc0ed806";
    hash = "sha256-Ovj/8T98pSWuLtSbfGVWf++ywSsa+PgXHiHxg6W7/m4=";
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
    httptools
    huggingface-hub
    jinja2
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
    formatron
    kbnf
    uvicorn
    uvloop # linux and x86_64
    exllamav2
  ];

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail 'fastapi-slim' 'fastapi'
    substituteInPlace pyproject.toml --replace-fail "numpy < 2.0.0" "numpy"
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
