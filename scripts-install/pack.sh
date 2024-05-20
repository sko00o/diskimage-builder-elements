#!/usr/bin/env bash

cd "$(dirname "$0")"

cp -av ../health-check/static/* static/
cp -av ../node-exporter/static/* static/
cp -av ../docker-ce/static/* static/
cp -av ../comfyui/static/* static/
cp -av ../rvcwebui/static/* static/

cp -av ../health-check/bin/* static/usr/local/bin/
cp -av ../systemd-jupyterlab/bin/* static/usr/local/bin/
cp -av ../prometheus/bin/* static/usr/local/bin/
cp -av ../open-webui/bin/* static/usr/local/bin/

cp -av ../comfyui/bin/* static/usr/local/bin/
cp -av ../rvc-webui-public-data/bin/* static/usr/local/bin/
cp -av ../sd-webui-common/bin/* static/usr/local/bin/
cp -av ../fooocus/bin/* static/usr/local/bin/

tar -czvf scripts.tgz -C static/ .
