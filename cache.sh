#!/bin/sh
packages=("comfyui" "exllamav2" "autogptq" "tensor_parallel" "text-generation-inference" "lycoris-lora" "open-clip-torch" "dadaptation" "prodigyopt" "kohya_ss")

for package in ${packages[*]}; do
  echo "nix build .#$package"
  nix build .#$package --json |  jq -r '.[].outputs | to_entries[].value' | cachix push nix-ai-stuff
done
