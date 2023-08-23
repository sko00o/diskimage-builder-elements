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

NVIDIA_DRIVER_FILE=${NVIDIA_DRIVER_FILE:-"/tmp/NVIDIA-Linux-x86_64-${NVIDIA_DRIVER_VERSION}.run"}

install_kernel_headers() {
    sudo apt-get -y install linux-headers-$(uname -r)
}

install_nvidia_driver() {
    install_kernel_headers

    if [ ! -f "${NVIDIA_DRIVER_FILE}" ]; then
        ## For example:
        ## Data Center Driver For Linux X64
        ##   https://us.download.nvidia.com/tesla/535.86.10/NVIDIA-Linux-x86_64-535.86.10.run
        ## Linux X64 (AMD64/EM64T) Display Driver
        ##   https://us.download.nvidia.com/XFree86/Linux-x86_64/535.98/NVIDIA-Linux-x86_64-535.98.run
        wget -O "${NVIDIA_DRIVER_FILE}" "$NVIDIA_DRIVER_REPO/${NVIDIA_DRIVER_TYPE}/${NVIDIA_DRIVER_VERSION}/NVIDIA-Linux-x86_64-${NVIDIA_DRIVER_VERSION}.run"
    fi
    sudo sh "${NVIDIA_DRIVER_FILE}" --no-questions

    echo "nvidia-driver ${NVIDIA_DRIVER_VERSION} for ${NVIDIA_DRIVER_TYPE} installed"
}

cleanup_nvidia_driver() {
    rm -rf "${NVIDIA_DRIVER_FILE}"
}

CUDA_RUNFILE_URL=${CUDA_RUNFILE_URL:-"https://developer.download.nvidia.com/compute/cuda/12.2.1/local_installers/cuda_12.2.1_535.86.10_linux.run"}
CUDA_RUNFILE_FILE=${CUDA_RUNFILE_FILE:-"/tmp/cuda_12.2.1_535.86.10_linux.run"}

install_cuda_toolkit() {
    if [ ! -f ${CUDA_RUNFILE_FILE} ]; then
        wget -O "${CUDA_RUNFILE_FILE}" "${CUDA_RUNFILE_URL}"
    fi
    sudo sh "${CUDA_RUNFILE_FILE}" --toolkit --silent

    echo "cuda-toolkit installed"
}

cleanup_cuda_toolkit() {
    rm -rf "${CUDA_RUNFILE_FILE}"
}
