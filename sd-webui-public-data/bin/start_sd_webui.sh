#!/usr/bin/env bash
SD_WEBUI_DIR=${SD_WEBUI_DIR:-"/root/stable-diffusion-webui"}
SD_WEBUI_DATA_DIR=${SD_WEBUI_DATA_DIR:-"/root/sd_webui_data"}
SD_WEBUI_PORT=${SD_WEBUI_PORT:-"10000"}

if ! $(conda env list | grep -q "sd_webui"); then
    echo "Creating conda env 'sd_webui'"
    conda create -y --name sd_webui python=3.10.12
fi

if ! ldconfig -p | grep -q libtcmalloc_minimal.so.4; then
    echo "Installing libtcmalloc-minimal4"
    sudo apt-get -y install libtcmalloc-minimal4
fi

for d in {embeddings,extensions,models}; do
    td="${SD_WEBUI_DATA_DIR}/${d}"
    if [ ! -d "${td}" ]; then
      mkdir -p "${td}"
    fi
done

cd "${SD_WEBUI_DIR}" && ./webui.sh -f \
    --listen \
    --port "${SD_WEBUI_PORT}" \
    --data-dir "${SD_WEBUI_DATA_DIR}" \
    --enable-insecure-extension-access \
    --gradio-queue \
    --no-download-sd-model \
    --api \
    --xformers \
    $@

