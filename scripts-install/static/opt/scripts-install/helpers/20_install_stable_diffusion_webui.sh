#!/bin/bash

SD_WEBUI_TAG=${SD_WEBUI_TAG:-"v1.5.2"}
SD_WEBUI_REPO=${SD_WEBUI_REPO:-"https://github.com/AUTOMATIC1111/stable-diffusion-webui.git"}
SD_WEBUI_DIR=${SD_WEBUI_DIR:-"${HOME}/stable-diffusion-webui"}

SD_WEBUI_DATA_DIR=${SD_WEBUI_DATA_DIR:-"${SD_WEBUI_DIR}"}
SD_WEBUI_CKPT=${SD_WEBUI_CKPT:-"${SD_WEBUI_DATA_DIR}/models/Stable-diffusion/v1-5-pruned-emaonly.safetensors"}
SD_WEBUI_CKPT_URL=${SD_WEBUI_CKPT_URL:-"https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.safetensors"}
SD_WEBUI_PORT=${SD_WEBUI_PORT:-"10000"}
SD_WEBUI_EXT_DIR=${SD_WEBUI_EXT_DIR:-"${SD_WEBUI_DATA_DIR}/extensions"}

ADETAILER_TAG=${ADETAILER_TAG:-"v23.8.1"}
CONTROLNET_COMMIT=${CONTROLNET_COMMIT:-"c3b32f2"}

download_sd_model() {
    if [ ! -f "${SD_WEBUI_CKPT}" ]; then
        mkdir -p "$(dirname "${SD_WEBUI_CKPT}")"
        wget -O "${SD_WEBUI_CKPT}" "${SD_WEBUI_CKPT_URL}"
    fi
}

download_sd_extensions() {
    mkdir -p "${SD_WEBUI_EXT_DIR}"
    if [ ! -d "${SD_WEBUI_EXT_DIR}/adetailer" ]; then
        git clone -b "${ADETAILER_TAG}" https://github.com/Bing-su/adetailer.git "${SD_WEBUI_EXT_DIR}/adetailer"
    fi
    if [ ! -d "${SD_WEBUI_EXT_DIR}/sd-webui-controlnet" ]; then
        git clone https://github.com/Mikubill/sd-webui-controlnet "${SD_WEBUI_EXT_DIR}/sd-webui-controlnet"
        cd "${SD_WEBUI_EXT_DIR}/sd-webui-controlnet" && git reset --hard "${CONTROLNET_COMMIT}"
    fi
}

launch_sd_webui() {
    for d in {embeddings,extensions,models}; do
        mkdir -p "${SD_WEBUI_DATA_DIR}/${d}"
    done

    cd "${SD_WEBUI_DIR}"
    ./webui.sh -f \
        --listen \
        --port ${SD_WEBUI_PORT} \
        --xformers \
        --enable-insecure-extension-access \
        --gradio-queue \
        --data-dir ${SD_WEBUI_DATA_DIR} \
        --no-download-sd-model
}

pre_install_sd_webui() {
    sudo apt-get -y install git cmake wget
    sudo apt-get -y install libtcmalloc-minimal4
    # if dir not found, clone
    if [ ! -d "${SD_WEBUI_DIR}" ]; then
        git clone -b "${SD_WEBUI_TAG}" "${SD_WEBUI_REPO}" "${SD_WEBUI_DIR}"
    fi
}

install_sd_webui() {
    pre_install_sd_webui
    cd "${SD_WEBUI_DIR}"

    install_miniconda
    conda create -y -n sd_webui python=3.10
    $(conda info --base)/envs/sd_webui/bin/python3.10 -m venv venv

    # PyTorch
    # pip install \
    #     torch==2.0.1+cu118 \
    #     torchvision==0.15.2+cu118 \
    #     torchaudio==2.0.2 \
    #     --index-url https://download.pytorch.org/whl/cu118
    # GFPGAN
    #pip install git+https://github.com/TencentARC/GFPGAN.git --prefer-binary
    # CodeFormer
    #git clone https://github.com/sczhou/CodeFormer.git repositories/CodeFormer

    # launch and wait, It will take long time on first boot
    launch_sd_webui
}
