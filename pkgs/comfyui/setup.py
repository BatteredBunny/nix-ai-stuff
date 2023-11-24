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
        "comfy.ldm.models",
        "comfy.ldm.modules",
        "comfy.ldm.modules.encoders",
        "comfy.ldm.modules.distributions",
        "comfy.ldm.modules.diffusionmodules",
        "comfy.t2i_adapter",
        "comfy.taesd",
        "comfy_extras",
        "comfy_extras.chainner_models",
        "comfy_extras.chainner_models.architecture",
        "comfy_extras.chainner_models.architecture.face",
        "comfy_extras.chainner_models.architecture.timm",
        "comfy_extras.chainner_models.architecture.OmniSR",
    ],
)
