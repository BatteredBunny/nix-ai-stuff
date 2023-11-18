{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

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

        nvidia = pkgs.callPackage ./nvidia.nix {};

        exllamav2 = pkgs.callPackage ./pkgs/exllamav2.nix {nvidia = nvidia;};
        gekko = pkgs.callPackage ./pkgs/gekko.nix {};
        autogptq = pkgs.callPackage ./pkgs/autogptq.nix {
          gekko = gekko;
          nvidia = nvidia;
        };
        lmstudio = pkgs.callPackage ./pkgs/lmstudio.nix {};
        ava = pkgs.callPackage ./pkgs/ava.nix {};
        tensor_parallel = pkgs.callPackage ./pkgs/tensor_parallel.nix {};
        text-generation-inference = pkgs.callPackage ./pkgs/text-generation-inference.nix {};
      in
        with pkgs; {
          overlay = final: prev: {
            exllamav2 = exllamav2;
            gekko = gekko;
            autogptq = autogptq;
            lmstudio = lmstudio;
            ava = ava;
            tensor_parallel = tensor_parallel;
            text-generation-inference = text-generation-inference;
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

          packages.exllamav2 = exllamav2;
          packages.gekko = gekko;
          packages.autogptq = autogptq;
          packages.lmstudio = lmstudio;
          packages.ava = ava;
          packages.tensor_parallel = tensor_parallel;
          packages.text-generation-inference = text-generation-inference;
        }
    );
}
