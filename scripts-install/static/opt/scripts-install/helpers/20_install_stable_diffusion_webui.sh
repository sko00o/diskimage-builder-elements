#!/bin/bash

SD_WEBUI_TAG=${SD_WEBUI_TAG:-"v1.5.2"}
SD_WEBUI_REPO=${SD_WEBUI_REPO:-"https://github.com/AUTOMATIC1111/stable-diffusion-webui.git"}
SD_WEBUI_DIR=${SD_WEBUI_DIR:-"${HOME}/stable-diffusion-webui"}
SD_WEBUI_PORT=${SD_WEBUI_PORT:-"10000"}

SD_WEBUI_DATA_DIR=${SD_WEBUI_DATA_DIR:-"${SD_WEBUI_DIR}"}
SD_WEBUI_CKPT=${SD_WEBUI_CKPT:-"${SD_WEBUI_DATA_DIR}/models/Stable-diffusion/v1-5-pruned-emaonly.safetensors"}
SD_WEBUI_CKPT_URL=${SD_WEBUI_CKPT_URL:-"https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.safetensors"}
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
    cd "${SD_WEBUI_DIR}" && ./webui.sh -f \
        --listen \
        --port ${SD_WEBUI_PORT} \
        --data-dir ${SD_WEBUI_DATA_DIR} \
        --enable-insecure-extension-access \
        --gradio-queue \
        --no-download-sd-model \
        --xformers \
        $@
}

install_sd_requirements() {
    for d in {embeddings,extensions,models}; do
        mkdir -p "${SD_WEBUI_DATA_DIR}/${d}"
    done

    # terminate after installation
    launch_sd_webui --exit --skip-torch-cuda-test
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
    conda create -y -n sd_webui python=3.10.13
    $(conda info --base)/envs/sd_webui/bin/python3 -m venv venv

    install_sd_requirements
}

install_sd_webui_from_public_data() {
    cd /root/
    # sd_webui v1.5.2 and all dependencies already compressed
    tar -xvf public/sd_webui/sd_webui.tar.xz
    cp -r public/sd_webui/data/models sd_webui_data/
    cp -r public/sd_webui/data/embeddings sd_webui_data/
    ./start_sd_webui.sh
}
