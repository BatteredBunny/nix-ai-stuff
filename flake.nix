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
          inherit gekko;
        };
        lmstudio = pkgs.callPackage ./pkgs/lmstudio.nix {};
        ava = pkgs.callPackage ./pkgs/ava.nix {};
        tensor_parallel = pkgs.callPackage ./pkgs/tensor_parallel.nix {};
        text-generation-inference = pkgs.callPackage ./pkgs/text-generation-inference.nix {};
        comfyui = pkgs.callPackage ./pkgs/comfyui/default.nix {};

        pymatting = pkgs.callPackage ./pkgs/pymatting.nix {};
        rembg = pkgs.callPackage ./pkgs/rembg.nix {
          inherit pymatting;
        };
        colorlog = pkgs.callPackage ./pkgs/colorlog.nix {};
        tensordict = pkgs.callPackage ./pkgs/tensordict.nix {};
        lpips = pkgs.callPackage ./pkgs/lpips.nix {};
        convcolors = pkgs.callPackage ./pkgs/convcolors.nix {};
        extcolors = pkgs.callPackage ./pkgs/extcolors.nix {
          inherit convcolors;
        };
        easydev = pkgs.callPackage ./pkgs/easydev.nix {
          inherit colorlog;
        };
        diffusers = pkgs.callPackage ./pkgs/diffusers.nix {};
        basicsr = pkgs.callPackage ./pkgs/basicsr.nix {};
        blendmodes = pkgs.callPackage ./pkgs/blendmodes.nix {};
        facexlib = pkgs.callPackage ./pkgs/facexlib.nix {};
        open-clip-torch = pkgs.callPackage ./pkgs/open-clip-torch.nix {};
        tomesd = pkgs.callPackage ./pkgs/tomesd.nix {};
        compel = pkgs.callPackage ./pkgs/compel.nix {
          inherit diffusers;
        };
        clip-interrogator = pkgs.callPackage ./pkgs/clip-interrogator.nix {
          inherit open-clip-torch;
        };
        gfpgan = pkgs.callPackage ./pkgs/gfpgan.nix {
          inherit basicsr facexlib;
        };
        sd-next = pkgs.callPackage ./pkgs/sd-next/default.nix {
          inherit easydev diffusers extcolors compel clip-interrogator blendmodes basicsr facexlib gfpgan lpips open-clip-torch tensordict tomesd rembg;
        };
      in
        with pkgs; {
          overlay = final: prev: {
            inherit exllamav2 gekko autogptq lmstudio ava tensor_parallel text-generation-inference comfyui basicsr blendmodes gfpgan facexlib open-clip-torch tomesd sd-next clip-interrogator diffusers easydev convcolors extcolors lpips tensordict colorlog rembg pymatting;
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
            inherit exllamav2 gekko autogptq lmstudio ava tensor_parallel text-generation-inference comfyui basicsr blendmodes gfpgan facexlib open-clip-torch tomesd sd-next clip-interrogator diffusers easydev convcolors extcolors lpips tensordict colorlog rembg pymatting;
          };
        }
    );
}
