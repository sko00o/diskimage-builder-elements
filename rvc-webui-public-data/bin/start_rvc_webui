#!/usr/bin/env bash

RVC_WEBUI_DIR=${RVC_WEBUI_DIR:-"/root/RVC-WebUI"}
RVC_WEBUI_VENV_DIR=${RVC_WEBUI_VENV_DIR:-"/root/RVC-WebUI/venv"}
RVC_WEBUI_PORT=${RVC_WEBUI_PORT:-"8080"}

# install ffmpeg if ffmpeg or ffprob not installed 
if ! command -v ffmpeg >/dev/null 2>&1 || ! command -v ffprobe >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get -y install ffmpeg
fi

# active python venv if not active
if [ -z "$VIRTUAL_ENV" ]; then
    source ${RVC_WEBUI_VENV_DIR}/bin/activate
fi

# launch
cd ${RVC_WEBUI_DIR} && python infer-web.py \
        --port "${RVC_WEBUI_PORT}" \
        --noautoopen \
        $@
