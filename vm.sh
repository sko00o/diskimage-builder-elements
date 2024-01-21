#!/bin/bash
set -e

cd "$(dirname "$0")"

# if multipass not installed, install it
if ! command -v multipass &> /dev/null; then
  sudo snap install multipass --classic
fi

# if imgbuild not found, create it
if ! multipass list | grep -q imgbuild; then
  multipass launch \
    --name imgbuild \
    --cpus 4 --memory 8G --disk 80G \
    --mount $(pwd):/root/build \
    --cloud-init cloud-init.yaml \
    22.04
fi

# attack the imgbuild vm
multipass exec imgbuild -- sudo -i
