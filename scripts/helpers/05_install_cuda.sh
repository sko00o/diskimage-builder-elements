#!/bin/bash

# https://docs.nvidia.com/datacenter/tesla/drivers/index.html#driver-install

CUDA_REPO=${CUDA_REPO:-"https://developer.download.nvidia.com/compute/cuda/repos"}
CUDA_DRIVER_VERSION=${CUDA_DRIVER_VERSION:-"530.30.02"}
CUDA_VERSION=${CUDA_VERSION:-"11.8.0"}
CUDNN_VERSION=${CUDNN_VERSION:-"8.6.0.163"}

version_short() {
    version=$1
    major=${version%%.*}
    minor=${version#"${major}."}
    minor=${minor%%.*}
    echo "${major}.${minor}"
}

# https://docs.nvidia.com/datacenter/tesla/tesla-installation-notes/index.html#ubuntu-lts
install_keyring() {
    # Check if keyring already installed
    if dpkg -s cuda-keyring &>/dev/null; then
        echo "The cuda-keyring is already installed."
        return
    fi

    distribution=$(
        . /etc/os-release
        echo $ID$VERSION_ID | sed -e 's/\.//g'
    )
    wget ${CUDA_REPO}/$distribution/x86_64/cuda-keyring_1.0-1_all.deb
    sudo dpkg -i cuda-keyring_1.0-1_all.deb
    sudo apt-get -y update
    # Clean up
    rm cuda-keyring_1.0-1_all.deb
}

install_cuda_driver() {
    major_version=${CUDA_DRIVER_VERSION%%.*}
    sudo apt-get -y install --no-install-recommends \
        cuda-drivers-${major_version}=${CUDA_DRIVER_VERSION}-1
}

# Installs all CUDA Toolkit packages required to develop CUDA applications. Does not include the driver.
install_cuda_toolkit() {
    cuda_version=$(version_short $CUDA_VERSION)
    sudo apt-get -y install \
        cuda-toolkit-${cuda_version//./-}=$CUDA_VERSION-1
}

install_cudnn() {
    cuda_version=$(version_short $CUDA_VERSION)
    sudo apt-get -y install \
        libcudnn8=$CUDNN_VERSION-1+cuda${cuda_version} \
        libcudnn8-dev=$CUDNN_VERSION-1+cuda${cuda_version}
}

# all in one
install_cuda() {
    install_keyring
    install_cuda_driver
    install_cuda_toolkit
    install_cudnn
}
