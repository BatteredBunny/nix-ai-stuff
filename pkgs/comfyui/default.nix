{
  lib,
  fetchFromGitHub,
  python3Packages,
  python3,
  pkgs,
}:
python3Packages.buildPythonApplication rec {
  pname = "comfyui";
  version = "unstable-2023-11-23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "comfyanonymous";
    repo = "ComfyUI";
    rev = "022033a0e75901c7c357ab96e1c804fd5da05770";
    hash = "sha256-gRZ7Pf8RRUwqbNtoFg7cnNF0uYVuE+qBXrrrw02/PAE=";
  };

  propagatedBuildInputs = with python3Packages; [
    torch
    torchsde
    einops
    transformers
    safetensors
    aiohttp
    accelerate
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

  postFixup = ''
    sed -i -e '1i#!/usr/bin/python' $out/bin/main.py
    patchShebangs $out/bin/main.py

    wrapProgram "$out/bin/main.py" \
      --prefix PYTHONPATH : "$PYTHONPATH" \

    mv $out/bin/*.py $out/lib/python3*/site-packages/
    ln -s $out/lib/python3*/site-packages/main.py $out/bin/comfyui
  '';

  postInstall = ''
    cp -r comfy $out/lib/python3*/site-packages/
    cp -r comfy_extras $out/lib/python3*/site-packages/

    cp -r web $out/lib
  '';

  meta = with lib; {
    description = "The most powerful and modular stable diffusion GUI with a graph/nodes interface";
    homepage = "https://github.com/comfyanonymous/ComfyUI";
    license = licenses.gpl3Only;
    mainProgram = "comfyui";
    platforms = platforms.all;
  };
}
