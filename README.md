> [!NOTE]
> Please note that most of the packages may not have binary cache, and building anything CUDA is very painful and slow.

# nix-ai-stuff
Nix flake for several AI projects focusing on nvidia/CUDA.

## Packages
- [kbnf](https://github.com/Dan-Wanna-M/kbnf) 0.4.1
- [general-sam](https://github.com/ModelTC/general-sam-py) 1.0.1
- [formatron](https://github.com/Dan-wanna-M/formatron) 0.4.11
- [tabbyapi](https://github.com/theroyallab/tabbyAPI) unstable-2025-04-16
- [exllamav2](https://github.com/turboderp/exllamav2) 0.2.9
- [autogptq](https://github.com/PanQiWei/AutoGPTQ) 0.7.1
- [ava & ava-headless](https://www.avapls.com/) 2024-04-24
- [ava-prebuilt](https://www.avapls.com/) 2024-04-21
- [tensor_parallel](https://github.com/BlackSamorez/tensor_parallel) 2.0.0
- [dadaptation](https://github.com/facebookresearch/dadaptation) 3.1
- [prodigyopt](https://github.com/konstmish/prodigy) 1.0
- [lycoris-lora](https://github.com/KohakuBlueleaf/LyCORIS) 2.0.2
- [kohya_ss](https://github.com/bmaltais/kohya_ss) 22.6.1 (patched to run without having to include web files)
- [flash-attn](https://github.com/Dao-AILab/flash-attention) 2.7.4
- [rouge](https://github.com/pltrdy/rouge) 1.0.1

```
nix run github:BatteredBunny/nix-ai-stuff#tabbyapi
```

# Similar projects
- [nixifed-ai](https://github.com/nixified-ai/flake)
