# nix-ai-stuff
Nix flake for several AI projects focusing on nvidia/CUDA.

## Packages
- [tabbyapi](https://github.com/theroyallab/tabbyAPI) unstable-2025-11-25
- [exllamav2](https://github.com/turboderp-org/exllamav2) 0.3.2
- [exllamav3](https://github.com/turboderp-org/exllamav3) 0.0.18
- [tensor_parallel](https://github.com/BlackSamorez/tensor_parallel) 2.0.0
- [lycoris-lora](https://github.com/KohakuBlueleaf/LyCORIS) 2.0.2
- [rouge](https://github.com/pltrdy/rouge) 1.0.1

```
nix run github:BatteredBunny/nix-ai-stuff#tabbyapi
```

## Overlay usage

Optional but recommended is to use the cachix cache to not build the packages yourself.

```bash
cachix use nix-ai-stuff
```

```nix
# flake.nix
inputs = {
    nix-ai-stuff.url = "github:BatteredBunny/nix-ai-stuff";
};
```

```nix
# configuration.nix
nixpkgs = {
    overlays = [
        inputs.nix-ai-stuff.overlays.default
    ];
    config = {
        allowUnfree = true;
        cudaSupport = true;
    };
};

environment.systemPackages = with pkgs; [
    tabbyapi # Api for exllama
];
```

# Similar projects
- [nixifed-ai](https://github.com/nixified-ai/flake)
