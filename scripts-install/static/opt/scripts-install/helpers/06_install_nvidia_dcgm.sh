#!/bin/bash

DCGM_VERSION="${DCGM_VERSION:-"3.2.5"}"

install_dcgm() {
    sudo apt-get -y install datacenter-gpu-manager="1:${DCGM_VERSION}"
    sudo systemctl enable nvidia-dcgm
    sudo systemctl start nvidia-dcgm
    echo "dcgm $DCGM_VERSION installed"
}
