#!/bin/bash

# https://www.nvidia.com/Download/index.aspx

NVIDIA_DRIVER_REPO=${NVIDIA_DRIVER_REPO:-"https://us.download.nvidia.com"}

# NVIDIA_DRIVER_TYPE:
# - tesla
# - XFree86/Linux-x86_64
NVIDIA_DRIVER_TYPE=${NVIDIA_DRIVER_TYPE:-"tesla"}
# NVIDIA_DRIVER_VERSION:
# - tesla: https://docs.nvidia.com/datacenter/tesla/index.html
# - Linux x86_64/AMD64/EM64T: https://www.nvidia.com/en-us/drivers/unix/
NVIDIA_DRIVER_VERSION=${NVIDIA_DRIVER_VERSION:-"535.86.10"}

install_nvidia_driver() {
    ## For example:
    ## Data Center Driver For Linux X64
    ##   https://us.download.nvidia.com/tesla/535.86.10/NVIDIA-Linux-x86_64-535.86.10.run
    ## Linux X64 (AMD64/EM64T) Display Driver
    ##   https://us.download.nvidia.com/XFree86/Linux-x86_64/535.98/NVIDIA-Linux-x86_64-535.98.run
    filename="NVIDIA-Linux-x86_64-${NVIDIA_DRIVER_VERSION}.run"
    wget -O ${filename} "$NVIDIA_DRIVER_REPO/${NVIDIA_DRIVER_TYPE}/${NVIDIA_DRIVER_VERSION}/${filename}"

    sudo sh "${filename}" --no-questions

    # cleanup
    rm -rf "${filename}"

    echo "nvidia-driver ${NVIDIA_DRIVER_VERSION} for ${NVIDIA_DRIVER_TYPE} installed"
}

CUDA_RUNFILE_URL=${CUDA_RUNFILE_URL:-"https://developer.download.nvidia.com/compute/cuda/12.2.1/local_installers/cuda_12.2.1_535.86.10_linux.run"}

install_cuda_toolkit() {
    filename="cuda_linux.run"
    wget -O ${filename} "${CUDA_RUNFILE_URL}"
    sudo sh ${filename} --toolkit --silent
    rm -rf "${filename}"
}
