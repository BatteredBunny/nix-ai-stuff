{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-ai-stuff.cachix.org"
      "https://nix-community.cachix.org"
      "https://ai.cachix.org"
    ];

    extra-trusted-public-keys = [
      "nix-ai-stuff.cachix.org-1:WlUGeVCs26w9xF0/rjyg32PujDqbVMlSHufpj1fqix8="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="
    ];
  };

  outputs =
    { nixpkgs
    , flake-utils
    , ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            cudaSupport = true;
          };
        };

        spandrelCommon = pkgs.callPackage ./pkgs/spandrel { };
      in
      rec {
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
          exllamav2 = pkgs.callPackage ./pkgs/exllamav2.nix { };
          autogptq = pkgs.callPackage ./pkgs/autogptq.nix { inherit rouge; };
          ava-prebuilt = pkgs.callPackage ./pkgs/ava/prebuilt.nix { };
          ava = pkgs.callPackage ./pkgs/ava { };
          ava-headless = pkgs.callPackage ./pkgs/ava { headless = true; };
          tensor_parallel = pkgs.callPackage ./pkgs/tensor_parallel.nix { };
          text-generation-inference = pkgs.callPackage ./pkgs/text-generation-inference.nix { };
          comfyui = pkgs.callPackage ./pkgs/comfyui { inherit spandrel spandrel_extra_arches; };
          lycoris-lora = pkgs.callPackage ./pkgs/lycoris-lora.nix { };
          open-clip-torch = pkgs.callPackage ./pkgs/open-clip-torch.nix { };
          dadaptation = pkgs.callPackage ./pkgs/dadaptation.nix { };
          prodigyopt = pkgs.callPackage ./pkgs/prodigyopt.nix { };
          kohya_ss = pkgs.callPackage ./pkgs/kohya_ss {
            inherit dadaptation prodigyopt;
          };
          spandrel = spandrelCommon.spandrel;
          spandrel_extra_arches = spandrelCommon.spandrel_extra_arches;
          rouge = pkgs.callPackage ./pkgs/rouge.nix { };
          flash-attention = pkgs.callPackage ./pkgs/flash-attention.nix { };
          tabbyapi = pkgs.callPackage ./pkgs/tabbyapi.nix { exllamav2 = exllamav2; };
        };
      }
    );
}
