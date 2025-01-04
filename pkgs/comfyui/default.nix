{ lib
, fetchFromGitHub
, python3Packages
, python3
, pkgs
, spandrel
, spandrel_extra_arches
,
}:
python3Packages.buildPythonApplication rec {
  pname = "comfyui";
  version = "0.3.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "comfyanonymous";
    repo = "ComfyUI";
    rev = "v${version}";
    hash = "sha256-pnNAljJD16NQYw4m9NGce8ivnP/nn0Xwjehqe6RbC90=";
  };

  dependencies = with python3Packages; [
    torch
    torchsde
    torchvision
    torchaudio
    einops
    transformers
    tokenizers
    sentencepiece
    safetensors
    aiohttp
    pyyaml
    pillow
    scipy
    tqdm
    psutil

    # optional dependencies
    kornia
    spandrel
    spandrel_extra_arches
    soundfile
  ];

  postPatch =
    let
      setup = pkgs.substituteAll {
        src = ./setup.py;
        desc = meta.description;
        inherit pname version;
      };
    in
    ''
      ln -s ${setup} setup.py

      substituteInPlace folder_paths.py \
        --replace-fail "os.path.dirname(os.path.realpath(__file__))" "os.getcwd()"
    '';

  nativeBuildInputs = [ python3 ];

  postInstall = ''
    cp *.py $out/lib/python3*/site-packages/
    cp -r app $out/lib/python3*/site-packages/
    cp -r comfy $out/lib/python3*/site-packages/
    cp -r comfy_extras $out/lib/python3*/site-packages/
    cp -r web $out/lib/python3*/site-packages/
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
