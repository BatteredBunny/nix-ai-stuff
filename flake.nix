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
      in rec {
        overlay = final: prev: packages;

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            python3
            cudatoolkit
          ];

          shellHook = ''
            export CUDA_PATH=${pkgs.cudatoolkit}
          '';
        };

        packages = rec {
          exllamav2 = pkgs.callPackage ./pkgs/exllamav2.nix {};
          autogptq = pkgs.callPackage ./pkgs/autogptq.nix {};
          lmstudio = pkgs.callPackage ./pkgs/lmstudio.nix {};
          ava-prebuilt = pkgs.callPackage ./pkgs/ava/prebuilt.nix {};
          ava = pkgs.callPackage ./pkgs/ava {};
          ava-headless = pkgs.callPackage ./pkgs/ava {headless = true;};
          tensor_parallel = pkgs.callPackage ./pkgs/tensor_parallel.nix {};
          text-generation-inference = pkgs.callPackage ./pkgs/text-generation-inference.nix {};
          comfyui = pkgs.callPackage ./pkgs/comfyui/default.nix {};
          lycoris-lora = pkgs.callPackage ./pkgs/lycoris-lora.nix {};
          open-clip-torch = pkgs.callPackage ./pkgs/open-clip-torch.nix {};
          dadaptation = pkgs.callPackage ./pkgs/dadaptation.nix {};
          prodigyopt = pkgs.callPackage ./pkgs/prodigyopt.nix {};
          kohya_ss = pkgs.callPackage ./pkgs/kohya_ss/default.nix {
            inherit dadaptation open-clip-torch prodigyopt;
          };
        };
      }
    );
}
