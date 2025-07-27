#!/usr/bin/env bash
packages=(
  "exllamav2"
  "exllamav3"
  "tabbyapi"
  "formatron"
  "tabbyapi"
  "autogptq"
  "ava"
  "ava-headless"
  "ava-prebuilt"
  "tensor_parallel"
  "dadaptation"
  "prodigyopt"
  "lycoris-lora"
  "kohya_ss"
  "flash-attn"
  "rouge"
)

for package in ${packages[*]}; do
  echo "nix build .#$package"
  nix build .#$package --json |  jq -r '.[].outputs | to_entries[].value' | cachix push nix-ai-stuff
done
