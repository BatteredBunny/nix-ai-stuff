{
  lib,
  python3Packages,
  fetchFromGitHub,
  open-clip-torch,
  dadaptation,
  prodigyopt,
  pkgs,
}: let
  xformers-cuda = pkgs.callPackage ./xformers-cuda.nix {};
  diffusers0-21-4 = pkgs.callPackage ./diffusers0-21-4.nix {
    inherit xformers-cuda;
  };
  lycoris-lora = pkgs.callPackage ../lycoris-lora.nix {
    diffusers = diffusers0-21-4;
  };
in
  python3Packages.buildPythonApplication rec {
    pname = "kohya_ss";
    version = "22.2.1";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "bmaltais";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-EzeRz2p24DDnNRzvftOKB+IlzL4/qfzvkiBA7YMV6oE=";
    };

    nativeBuildInputs = with python3Packages; [
      poetry-core
    ];

    propagatedBuildInputs = with python3Packages; [
      accelerate
      aiofiles
      altair
      dadaptation
      diffusers0-21-4
      easygui
      einops
      fairscale
      ftfy
      gradio
      huggingface-hub
      invisible-watermark
      lion-pytorch
      lycoris-lora
      onnx
      onnxruntime # onnxruntime-gpu
      open-clip-torch
      opencv4 # opencv-python
      prodigyopt
      protobuf
      pytorch-lightning
      rich
      safetensors
      timm
      tkinter # tk
      toml
      transformers
      voluptuous
      wandb
      bitsandbytes
    ];

    buildInputs = with pkgs; [
      onnxruntime
    ];

    # basically just replaces all the relative paths
    postPatch = ''
      substituteInPlace kohya_gui.py \
        --replace "if os.path.exists(\"./.release\"):" "release = \"v${version}\"
          if False:" \
        --replace "./style.css" "$out/lib/style.css" \
        --replace "\"./README.md\"" "\"$out/lib/README.md\""

      substituteInPlace lora_gui.py \
        --replace "./presets/lora" "$out/lib/presets/lora" \
        --replace "./style.css" "$out/lib/style.css" \
        --replace "\"./docs/LoRA/top_level.md\"" "\"$out/lib/docs/LoRA/top_level.md\"" \
        --replace "./sdxl_train_network.py" "$out/lib/sdxl_train_network.py" \
        --replace "./train_network.py" "$out/lib/train_network.py"

      substituteInPlace finetune_gui.py \
        --replace "'./docs/Finetuning/top_level.md'" "'$out/lib/docs/Finetuning/top_level.md'" \
        --replace "'./style.css'" "'$out/lib/style.css'" \
        --replace "./presets/finetune" "$out/lib/presets/finetune" \
        --replace "./sdxl_train.py" "$out/lib/sdxl_train.py" \
        --replace "./fine_tune.py" "$out/lib/fine_tune.py"

      substituteInPlace textual_inversion_gui.py \
        --replace "'./style.css'" "'$out/lib/style.css'" \
        --replace "./sdxl_train_textual_inversion.py" "$out/lib/sdxl_train_textual_inversion.py" \
        --replace "./train_textual_inversion.py" "$out/lib/train_textual_inversion.py"

      substituteInPlace library/utilities.py \
        --replace "'./style.css'" "'$out/lib/style.css'"

      substituteInPlace library/common_gui.py \
        --replace "./v2_inference/" "$out/lib/v2_inference/"

      substituteInPlace library/convert_model_gui.py \
        --replace "./v2_inference/" "$out/lib/v2_inference/"

      substituteInPlace library/localization.py \
        --replace "'./localizations'" "'$out/lib/localizations'"

      substituteInPlace library/wd14_caption_gui.py \
        --replace "./finetune/tag_images_by_wd14_tagger.py" "$out/lib/finetune/tag_images_by_wd14_tagger.py"

      substituteInPlace dreambooth_gui.py \
        --replace "./style.css" "$out/lib/style.css" \
        --replace "./train_db.py" "$out/lib/train_db.py" \
        --replace "./sdxl_train.py" "$out/lib/sdxl_train.py"
    '';

    postInstall = ''
      cp *.py $out/lib
      cp -r networks $out/lib/python3*/site-packages/
      cp README.md $out/lib
      cp -r presets $out/lib
      cp -r docs $out/lib
      cp style.css $out/lib
      cp -r v2_inference $out/lib
      cp -r localizations $out/lib
      cp -r finetune $out/lib
    '';

    postFixup = ''
      chmod +x $out/lib/kohya_gui.py
      sed -i -e '1i#!/usr/bin/python' $out/lib/kohya_gui.py
      patchShebangs $out/lib/kohya_gui.py

      mkdir -p $out/bin
      ln -s $out/lib/kohya_gui.py $out/bin/kohya_ss

      wrapProgram "$out/bin/kohya_ss" \
        --prefix PYTHONPATH : "$PYTHONPATH" \
        --prefix PATH : ${lib.makeBinPath [python3Packages.accelerate]} \
    '';

    pythonImportsCheck = ["library"];

    meta = with lib; {
      homepage = "https://github.com/bmaltais/kohya_ss";
      license = licenses.asl20;
      mainProgram = pname;
    };
  }
