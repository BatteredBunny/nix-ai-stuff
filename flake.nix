{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-ai-stuff.cachix.org"
      "https://nix-community.cachix.org"
      "https://cache.nixos-cuda.org"
      "https://ai.cachix.org"
    ];

    extra-trusted-public-keys = [
      "nix-ai-stuff.cachix.org-1:WlUGeVCs26w9xF0/rjyg32PujDqbVMlSHufpj1fqix8="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }:
    let
      inherit (nixpkgs) lib;

      systems = lib.systems.flakeExposed;

      forAllSystems = lib.genAttrs systems;

      nixpkgsFor = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            cudaSupport = true;
          };
        }
      );
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              python3
              cudatoolkit
            ];

            shellHook = ''
              export CUDA_PATH=${pkgs.cudatoolkit}
            '';
          };
        }
      );

      nixosModules = {
        tabbyapi = import ./modules/tabbyapi.nix;
      };

      overlays.default = final: prev: rec {
        # Removed packages
        flash-attn = throw "flash-attn has been upstreamed to nixpkgs";
        autogptq = throw "autogptq removed since the repo is archived";
        ava = throw "ava & ava-prebuilt removed since the package hasn't been updated in a while";
        ava-prebuilt = ava;
        ava-headless = ava;
        dadaptation = kohya_ss;
        prodigyopt = kohya_ss;
        kohya_ss = throw "kohya_ss package is unmaintained and broken";
        kbnf = throw "kbnf has been upstreamed to nixpkgs";
        general-sam = throw "general-sam has been upstreamed to nixpkgs";
        formatron = throw "formatron has been upstreamed to nixpkgs";
        exllamav2 = throw "exllamav2 has been upstreamed to nixpkgs";
        exllamav3 = throw "exllamav3 has been upstreamed to nixpkgs";
        tabbyapi = throw "tabbyapi has been upstreamed to nixpkgs";

        tabbyapiModelDir = final.callPackage ./pkgs/tabbyapiModelDir.nix { };
        tensor_parallel = final.callPackage ./pkgs/tensor_parallel.nix { };
        lycoris-lora = final.callPackage ./pkgs/lycoris-lora.nix { };
        open-clip-torch = final.callPackage ./pkgs/open-clip-torch.nix { };
        rouge = final.callPackage ./pkgs/rouge.nix { };
      };

      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
        in
        lib.makeScope pkgs.newScope (final: self.overlays.default final pkgs)
      );
    };
}
