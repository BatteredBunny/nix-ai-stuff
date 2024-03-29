{
  lib,
  fetchFromGitHub,
  python3Packages,
  python3,
  pkgs,
}:
python3Packages.buildPythonApplication rec {
  pname = "comfyui";
  version = "unstable-2024-03-23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "comfyanonymous";
    repo = "ComfyUI";
    rev = "a28a9dc83684624ee2167c0b92d976bb68f2c606";
    hash = "sha256-GxCgGBT3x7HcneoikwUmmWr/CSp8bDeDGD2tgMfCPe8=";
  };

  propagatedBuildInputs = with python3Packages; [
    torch
    torchsde
    einops
    transformers
    safetensors
    aiohttp
    pyyaml
    pillow
    scipy
    tqdm
    psutil
    kornia

    # nvidia deps
    torchvision
    torchaudio
  ];

  postPatch = let
    setup = pkgs.substituteAll {
      src = ./setup.py;
      desc = meta.description;
      inherit pname version;
    };
  in ''
    ln -s ${setup} setup.py

    substituteInPlace folder_paths.py \
      --replace "os.path.dirname(os.path.realpath(__file__))" "os.getcwd()"

    substituteInPlace server.py \
      --replace "os.path.join(os.path.dirname(" "\"$out/lib/web\"" \
      --replace "os.path.realpath(__file__)), \"web\")" ""
  '';

  nativeBuildInputs = [python3];

  postInstall = ''
    cp *.py $out/lib/python3*/site-packages/
    cp -r app $out/lib/python3*/site-packages/
    cp -r comfy $out/lib/python3*/site-packages/
    cp -r comfy_extras $out/lib/python3*/site-packages/

    cp -r web $out/lib
  '';

  postFixup = ''
    chmod +x $out/lib/python3*/site-packages/main.py
    sed -i -e '1i#!/usr/bin/python' $out/lib/python3*/site-packages/main.py
    patchShebangs $out/lib/python3*/site-packages/main.py

    mkdir $out/bin
    ln -s $out/lib/python3*/site-packages/main.py $out/bin/comfyui

    wrapProgram "$out/bin/comfyui" \
      --prefix PYTHONPATH : "$PYTHONPATH" \
  '';

  meta = with lib; {
    description = "The most powerful and modular stable diffusion GUI with a graph/nodes interface";
    homepage = "https://github.com/comfyanonymous/ComfyUI";
    license = licenses.gpl3Only;
    mainProgram = "comfyui";
    platforms = platforms.all;
  };
}
