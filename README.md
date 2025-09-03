> [!NOTE]
> Please note that most of the packages may not have binary cache, and building anything CUDA is very painful and slow.

# nix-ai-stuff
Nix flake for several AI projects focusing on nvidia/CUDA.

## Packages
- [kbnf](https://github.com/Dan-Wanna-M/kbnf) 0.4.2
- [general-sam](https://github.com/ModelTC/general-sam-py) 1.0.1
- [formatron](https://github.com/Dan-wanna-M/formatron) 0.5.0
- [tabbyapi](https://github.com/theroyallab/tabbyAPI) unstable-2025-08-26
- [exllamav2](https://github.com/turboderp-org/exllamav2) 0.3.2
- [exllamav3](https://github.com/turboderp-org/exllamav3) 0.0.6
- [tensor_parallel](https://github.com/BlackSamorez/tensor_parallel) 2.0.0
- [lycoris-lora](https://github.com/KohakuBlueleaf/LyCORIS) 2.0.2
- [flash-attn](https://github.com/Dao-AILab/flash-attention) 2.8.2
- [rouge](https://github.com/pltrdy/rouge) 1.0.1

```
nix run github:BatteredBunny/nix-ai-stuff#tabbyapi
```

# Similar projects
- [nixifed-ai](https://github.com/nixified-ai/flake)
