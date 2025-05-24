#!/bin/bash
set -ex

mkdir -p /workspace

apt-get update
apt-get install -y git wget python3 python3-pip ffmpeg

pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
pip3 install xformers transformers accelerate

git clone https://github.com/comfyanonymous/ComfyUI.git /workspace/ComfyUI
cd /workspace/ComfyUI
pip3 install -r requirements.txt

mkdir -p models/checkpoints models/hunyuan

wget -O models/checkpoints/sd15.safetensors https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.safetensors
wget -O models/hunyuan/hunyuan_model.safetensors https://huggingface.co/tencent/HunyuanVideo/resolve/main/hunyuan_model.safetensors
wget -O models/hunyuan/hunyuan_config.json https://huggingface.co/tencent/HunyuanVideo/resolve/main/hunyuan_config.json

nohup python3 main.py --listen 0.0.0.0 --port 8188 > /var/log/comfyui.log 2>&1 &
