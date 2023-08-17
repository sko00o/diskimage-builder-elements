#!/bin/bash
set -euxo pipefail

# https://docs.nvidia.com/datacenter/tesla/drivers/index.html#driver-install

NVIDIA_DRIVER_VERSION=${NVIDIA_DRIVER_VERSION:-"535"}
CUDA_VERSION=${CUDA_VERSION:-"11.8"}
CUDNN_VERSION=${CUDNN_VERSION:-"8.6.0.163"}

# https://docs.nvidia.com/datacenter/tesla/tesla-installation-notes/index.html#ubuntu-lts
install_keyring() {
    distribution=$(
        . /etc/os-release
        echo $ID$VERSION_ID | sed -e 's/\.//g'
    )
    wget https://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64/cuda-keyring_1.0-1_all.deb
    sudo dpkg -i cuda-keyring_1.0-1_all.deb
    sudo apt-get -y update
    # Clean up
    rm cuda-keyring_1.0-1_all.deb
}

install_nvidia_driver() {
    sudo apt-get -y install --no-install-recommends \
        nvidia-driver-${NVIDIA_DRIVER_VERSION}
}

# Installs all CUDA Toolkit packages required to develop CUDA applications. Does not include the driver.
install_cuda_toolkit() {
    sudo apt-get -y install \
        cuda-toolkit-${CUDA_VERSION//-/.}
}

install_cudnn() {
    sudo apt-get -y install \
        libcudnn8=$CUDNN_VERSION-1+cuda${CUDA_VERSION} \
        libcudnn8-dev=$CUDNN_VERSION-1+cuda${CUDA_VERSION}
}

# all in one
install_cuda() {
    install_keyring
    install_nvidia_driver
    install_cuda_toolkit
    install_cudnn
}

install_cuda
