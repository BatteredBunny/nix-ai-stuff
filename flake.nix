{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  nixConfig.extra-substituters = [
    "https://nix-ai-stuff.cachix.org"
    "https://cuda-maintainers.cachix.org"
    "https://ai.cachix.org"
  ];

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            cudaSupport = true;
          };
        };

        exllamav2 = pkgs.callPackage ./pkgs/exllamav2.nix {};
        gekko = pkgs.callPackage ./pkgs/gekko.nix {};
        autogptq = pkgs.callPackage ./pkgs/autogptq.nix {
          gekko = gekko;
        };
        lmstudio = pkgs.callPackage ./pkgs/lmstudio.nix {};
        ava = pkgs.callPackage ./pkgs/ava.nix {};
        tensor_parallel = pkgs.callPackage ./pkgs/tensor_parallel.nix {};
        text-generation-inference = pkgs.callPackage ./pkgs/text-generation-inference.nix {};
        comfyui = pkgs.callPackage ./pkgs/comfyui/default.nix {};
      in
        with pkgs; {
          overlay = final: prev: {
            inherit exllamav2 gekko autogptq lmstudio ava tensor_parallel text-generation-inference comfyui;
          };

          devShells.default = mkShell {
            buildInputs = [
              python3
              cudatoolkit
            ];

            shellHook = ''
              export CUDA_PATH=${cudatoolkit}
            '';
          };

          packages = {
            inherit exllamav2 gekko autogptq lmstudio ava tensor_parallel text-generation-inference comfyui;
          };
        }
    );
}
