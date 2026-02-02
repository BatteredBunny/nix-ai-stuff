#!/usr/bin/env bash
packages=(
  "tabbyapi"
  "tensor_parallel"
  "lycoris-lora"
  "rouge"
)

for package in ${packages[*]}; do
  echo "nix build .#$package"
  nix build .#$package --accept-flake-config --json |  jq -r '.[].outputs | to_entries[].value' | cachix push nix-ai-stuff
done
