{
  lib,
  fetchFromGitHub,
  python3Packages,
  python3,
  pkgs,
}:
python3Packages.buildPythonApplication rec {
  pname = "comfyui";
  version = "unstable-2024-01-02";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "comfyanonymous";
    repo = "ComfyUI";
    rev = "2c4e92a98b8338f754855a0db7dce164945e366e";
    hash = "sha256-yVE3nqvLKUGEd/y2o2hSbfbVM7WkL8EfGug/IYsuOX4=";
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
