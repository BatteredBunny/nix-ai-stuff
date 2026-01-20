{
  lib,
  fetchFromGitHub,
  python3Packages,
  stdenv,
}:
python3Packages.buildPythonApplication {
  pname = "tabbyapi";
  version = "unstable-2025-12-16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "theroyallab";
    repo = "tabbyAPI";
    rev = "f04fc6eb25521b922a8f9695c236ebef8f5a11fd";
    hash = "sha256-rz4a69vuQthu6i5llsqYlLqZql95LTVUuOVIlXmxqWk=";
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
    "pydantic" # Wants 2.11.0 but nixpkgs has newer version
  ];

  dependencies =
    with python3Packages;
    [
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

      exllamav2
      exllamav3
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      uvloop
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
    description = "Official API server for Exllama";
    homepage = "https://github.com/theroyallab/tabbyAPI";
    license = lib.licenses.agpl3Only;
    platforms = with lib.platforms; windows ++ linux;
    mainProgram = "tabbyapi";
    maintainers = with lib.maintainers; [ BatteredBunny ];
  };
}
