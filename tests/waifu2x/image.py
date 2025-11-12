import sys
#sys.path.append("/data/yss/app/nunif")
import torch
import threading
from PIL import Image
from waifu2x.hub import waifu2x

print(sys.path)
im = Image.open("tmp/images/miku_small.png")
model = waifu2x(
    model_type="art_scan",
    source="local",
    trust_repo=True).to("cuda")

lock = threading.Lock()
for noise_level in (-1, 0, 1, 2, 3):
    with lock: # Note model.set_mode -> model.infer block is not thread-safe
        # Select method and noise_level
        model.set_mode("scale", noise_level)
        out = model.infer(im)
    out.save(f"tmp/images/waifu2x_art_scan/noise_{noise_level}.png")
