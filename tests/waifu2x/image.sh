#!/bin/bash

# Denoise level 0 (-n noise_level)
DEBUG=1 python -m waifu2x.cli -m noise -n 0 -i tests/images -o tmp/images/waifu2x/noise

# 2x
python -m waifu2x.cli -m scale -i tests/images -o tmp/images/waifu2x/scale

# 4x + Denoise level 3
python -m waifu2x.cli -m noise_scale4x -n 3 -i tests/images -o tmp/images/waifu2x/noise_scale4x

# Using photo model (--style photo)
python -m waifu2x.cli --style photo -m noise_scale4x -n 3 --tile-size 640 --batch-size 1 -i tests/images -o tmp/images/waifu2x/noise_scale4x_photo

# Using art_scan model (--style scan or --style art_scan)
python -m waifu2x.cli --style scan -m noise_scale4x -n 3 -i tests/images -o tmp/images/waifu2x/noise_scale4x_scan

# With model dir
python -m waifu2x.cli --model-dir ./waifu2x/pretrained_models/upconv_7/photo/ -m noise_scale -n 1 -i tests/images -o tmp/images/waifu2x/noise_scale4x_upconv_7

# With multi GPU (--gpu gpu_ids)
python -m waifu2x.cli --gpu 0 1 2 3 -m scale -i tests/images -o tmp/images/waifu2x/scale_gpu

# With TTA
python -m waifu2x.cli --tta -m scale -i tests/images -o tmp/images/waifu2x/scale_tta