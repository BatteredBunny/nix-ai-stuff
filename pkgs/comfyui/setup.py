from setuptools import setup

with open("requirements.txt") as f:
    install_requires = f.read().splitlines()

setup(
    name="comfyui",
    description="The most powerful and modular stable diffusion GUI with a graph/nodes interface",
    install_requires=install_requires,
    packages=[
        "comfy",
        "comfy.cldm",
        "comfy.extra_samplers",
        "comfy.k_diffusion",
        "comfy.ldm",
        "comfy.ldm.audio",
        "comfy.ldm.aura",
        "comfy.ldm.cascade",
        "comfy.ldm.models",
        "comfy.ldm.modules",
        "comfy.ldm.modules.diffusionmodules",
        "comfy.ldm.modules.distributions",
        "comfy.ldm.modules.encoders",
        "comfy.t2i_adapter",
        "comfy.taesd",
        "comfy_extras",
        "comfy_extras.chainner_models",
    ],
)
