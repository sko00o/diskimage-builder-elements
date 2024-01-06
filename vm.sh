#!/bin/bash
set -e

cd "$(dirname "$0")"

# if imgbuild not found, create it
if ! multipass list | grep -q imgbuild; then
  multipass launch \
    --name imgbuild \
    --cpus 4 --memory 8G --disk 80G \
    --mount $(pwd):/root/build \
    --cloud-init cloud-init.yaml \
    22.04
fi

multipass exec imgbuild -- sudo -i
