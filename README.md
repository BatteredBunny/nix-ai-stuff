# nix-ai-stuff
Nix flake for several AI projects focusing on nvidia/CUDA.

## Packages
- [tensor_parallel](https://github.com/BlackSamorez/tensor_parallel) 2.0.0
- [lycoris-lora](https://github.com/KohakuBlueleaf/LyCORIS) 2.0.2
- [rouge](https://github.com/pltrdy/rouge) 1.0.1

```
nix run github:BatteredBunny/nix-ai-stuff#rouge
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
    };
};

environment.systemPackages = with pkgs; [
    pkgsCuda.tabbyapi # Api for exllama
];
```

## Using tabbyAPI on NixOS

```nix
imports = [
    inputs.nix-ai-stuff.nixosModules.tabbyapi
];

services.tabbyapi = {
    enable = true;
    package = pkgs.pkgsCuda.tabbyapi;
    settings = {
        model = {
            model_name = "qwen-8b";
            model_dir = pkgs.tabbyapiModelDir {
                qwen-8b = pkgs.fetchgit {
                    url = "https://huggingface.co/turboderp/Qwen3-VL-8B-Instruct-exl3";
                    rev = "652ab6be95b3e2880e78d87269013d98ca9c392d"; # 4bpw
                    fetchLFS = true;
                    hash = "sha256-n+9Mt7EZ3XHM0w8oGUZr4EBz91EFyp1VBpvl9Php/QM=";
                };
            };
        };
    };
};
```

# Similar projects
- [nixifed-ai](https://github.com/nixified-ai/flake)
