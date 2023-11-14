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

        exllamav2 = pkgs.callPackage ./exllamav2.nix {};
        gekko = pkgs.callPackage ./gekko.nix {};
        autogptq = pkgs.callPackage ./autogptq.nix { gekko = gekko; };
      in
        with pkgs; {
          overlay = final: prev: {
            exllamav2 = exllamav2;
            gekko = gekko;
            autogptq = autogptq;
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
        }
    );
}
