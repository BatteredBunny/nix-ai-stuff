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
  version = "unstable-2025-07-25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "theroyallab";
    repo = "tabbyAPI";
    rev = "0b4ca567f85a77461186ebf5a8721794d69ec924";
    hash = "sha256-P17jKzADsxfhPdWSnEsHioIQ4+TcEF0Z0a8mNH0Oiis=";
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
