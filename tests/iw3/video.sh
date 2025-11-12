#!/bin/bash

# 2D to 3D video
DEBUG=1 python -m iw3 -i tests/videos/Sticker.mp4 -o tmp/videos/waifu2x/Sticker_3d.mp4

# rtmp
python3 -m waifu2x.cli \
  --style photo \
  --method scale2x -n 3 \
  --gpu 0 1 2 3 \
  --crf 24 \
  --preset fast \
  --video-format flv \
  -i "rtmp://172.17.0.1/live/instream" \
  -o "rtmp://172.17.0.1/live/outstream"

python3 -m waifu2x.cli \
  --live \
  --style photo \
  --method scale2x -n 3 \
  --gpu 0 1 2 3 \
  --crf 24 \
  --preset fast \
  --video-format flv \
  -i "rtmp://172.17.0.1/live/instream" \
  -o "rtmp://172.17.0.1/live/outstream"
