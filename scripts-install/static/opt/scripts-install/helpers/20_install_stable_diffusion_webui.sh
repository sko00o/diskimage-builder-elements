#!/bin/bash

SD_WEBUI_TAG=${SD_WEBUI_TAG:-"v1.5.2"}
SD_WEBUI_REPO=${SD_WEBUI_REPO:-"https://github.com/AUTOMATIC1111/stable-diffusion-webui.git"}
SD_WEBUI_DIR=${SD_WEBUI_DIR:-"${HOME}/stable-diffusion-webui"}

SD_WEBUI_CKPT=${SD_WEBUI_CKPT:-"${SD_WEBUI_DIR}/models/Stable-diffusion/v1-5-pruned-emaonly.safetensors"}
SD_WEBUI_CKPT_URL=${SD_WEBUI_CKPT_URL:-"https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.safetensors"}
SD_WEBUI_PORT=${SD_WEBUI_PORT:-"10000"}

launch_sd_webui() {
    cd "${SD_WEBUI_DIR}"
    ./webui.sh -f \
        --listen \
        --port ${SD_WEBUI_PORT} \
        --xformers \
        --enable-insecure-extension-access \
        --gradio-queue \
        --ckpt ${SD_WEBUI_CKPT}
}

pre_install_sd_webui() {
    sudo apt-get -y install git cmake wget
    sudo apt-get -y install libtcmalloc-minimal4
    git clone -b "${SD_WEBUI_TAG}" "${SD_WEBUI_REPO}" "${SD_WEBUI_DIR}"
}

install_sd_webui() {
    pre_install_sd_webui
    cd "${SD_WEBUI_DIR}"

    # if python3 venv not found, install python3-venv
    if ! command -v python3-venv &>/dev/null; then
        sudo apt-get -y install python3-venv
    fi

    # if pip command not found, install pip
    if ! command -v pip &>/dev/null; then
        sudo apt-get -y install python3-pip
    fi

    python3 -m venv venv
    source venv/bin/activate
    # PyTorch
    pip install \
        torch==2.0.1+cu118 \
        torchvision==0.15.2+cu118 \
        torchaudio==2.0.2 \
        --index-url https://download.pytorch.org/whl/cu118
    # GFPGAN
    pip install \
        git+https://github.com/TencentARC/GFPGAN.git --prefer-binary
    # CodeFormer
    git clone https://github.com/sczhou/CodeFormer.git repositories/CodeFormer

    # download a sd model if you don't have
    wget -c -O "${SD_WEBUI_CKPT}" "${SD_WEBUI_CKPT_URL}"

    # launch and wait, It will take long time on first boot
    launch_sd_webui
}
