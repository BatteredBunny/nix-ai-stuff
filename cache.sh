#!/bin/sh
packages=(
  "exllamav2"
  "autogptq"
  "ava"
  "ava-headless"
  "ava-prebuilt"
  "tensor_parallel"
  "text-generation-inference"
  "comfyui"
  "dadaptation"
  "prodigyopt"
  "lycoris-lora"
  "kohya_ss"
  "spandrel"
  "spandrel_extra_arches"
  "flash-attention"
  "rouge"
)

for package in ${packages[*]}; do
  echo "nix build .#$package"
  nix build .#$package --json |  jq -r '.[].outputs | to_entries[].value' | cachix push nix-ai-stuff
done
