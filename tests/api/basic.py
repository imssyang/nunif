import torch
from PIL import Image

model = torch.hub.load(
    "/data/yss/app/nunif",
    "waifu2x",
    model_type="art",
    method="scale",
    noise_level=3,
    source="local",
    trust_repo=True).to("cuda")
input_image = Image.open("tmp/images/miku_small.png")
result = model.infer(input_image)
result.show() # result is PIL.Image.Image
