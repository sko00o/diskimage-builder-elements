#!/bin/bash

# https://www.nvidia.com/Download/index.aspx

NVIDIA_DRIVER_REPO=${NVIDIA_DRIVER_REPO:-"https://us.download.nvidia.com"}

# NVIDIA_DRIVER_TYPE:
# - XFree86/Linux-x86_64
# - tesla
NVIDIA_DRIVER_TYPE=${NVIDIA_DRIVER_TYPE:-"XFree86/Linux-x86_64"}
NVIDIA_DRIVER_VERSION=${NVIDIA_DRIVER_VERSION:-"535.98"}

install_nvidia_driver() {
    ## For example:
    ## Linux X64 (AMD64/EM64T) Display Driver
    ##   https://us.download.nvidia.com/XFree86/Linux-x86_64/535.98/NVIDIA-Linux-x86_64-535.98.run
    ## Data Center Driver For Linux X64
    ##   https://us.download.nvidia.com/tesla/535.86.10/NVIDIA-Linux-x86_64-535.86.10.run
    filename="NVIDIA-Linux-x86_64-${NVIDIA_DRIVER_VERSION}.run"
    download_url="$NVIDIA_DRIVER_REPO/${NVIDIA_DRIVER_TYPE}/${NVIDIA_DRIVER_VERSION}/${filename}"
    curl -sfL -o "${filename}" "${download_url}"

    sudo sh "${filename}" --no-questions

    # cleanup
    rm -rf "${filename}"
}
