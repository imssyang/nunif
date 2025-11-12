#!/bin/bash

DEBUG=1 python -m waifu2x.cli --style art --method noise_scale -i tests/videos/envivio-h264.mp4 -o tmp/videos/waifu2x/envivio_h264_art_noise_scale.mp4

# high quality encoding
python -m waifu2x.cli --crf 16 --preset medium --pix-fmt yuv444p --style art_scan --method noise -n 3 -i tests/videos/envivio-h264.mp4 -o tmp/videos/waifu2x/envivio_h264_art_scan_noise_crf16.mp4

# drop to 30fps from 60fps video (fps = min(original fps, --max-fps).
python -m waifu2x.cli --max-fps 30 --style art_scan --method noise -n 3 -i tests/videos/envivio-h264.mp4 -o tmp/videos/waifu2x/envivio_h264_art_scan_noise_30fps.mp4

# 1fps video (for preview)
python -m waifu2x.cli --max-fps 1 --style art_scan --method noise -n 3 -i tests/videos/envivio-h264.mp4 -o tmp/videos/waifu2x/envivio_h264_art_scan_noise_1fps.mp4

# fix rotation (width height swap, --rotate-left(counterclockwise) or --rotate-right(clockwise))
python -m waifu2x.cli --rotate-left --style photo --method noise -n 3 -i tests/videos/envivio-h264.mp4 -o tmp/videos/waifu2x/envivio_h264_photo_noise_rotate_left.mp4

# deinterlace input video stream. (you can use ffmpeg's video filter with --vf option)
python -m waifu2x.cli --vf yadif --style photo --method noise -n 3 -i tests/videos/envivio-h264.mp4 -o tmp/videos/waifu2x/envivio_h264_photo_noise_yadif.mp4

# add noise after denosing
python -m waifu2x.cli --grain --style photo --method noise -n 3 -i tests/videos/envivio-h264.mp4 -o tmp/videos/waifu2x/envivio_h264_photo_noise_grain.mp4

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
