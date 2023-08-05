#!/bin/bash

# Reference:
# https://docs.nvidia.com/networking/display/public/SOL/HowTo+Create+OpenStack+Cloud+Image+with+NVIDIA+GPU+and+Network+Drivers#HowToCreateOpenStackCloudImagewithNVIDIAGPUandNetworkDrivers-AbbreviationsandAcronyms

if [ ${DIB_DEBUG_TRACE:-0} -gt 0 ]; then
    set -x
fi
set -o errexit
set -o nounset
set -o pipefail

# Use current shell path as elements path
export ELEMENTS_PATH="$(dirname "$0")"
export DIB_RELEASE=bionic # ubuntu18.04

## Setup env for mofed-ubuntu
MLNX_OFED_IMG="MLNX_OFED_LINUX-5.8-3.0.7.0-ubuntu18.04-x86_64.iso"
export DIB_MOFED_FILE="$ELEMENTS_PATH/$MLNX_OFED_IMG"
if [ ! -f $MLNX_OFED_IMG ]; then
    wget https://content.mellanox.com/ofed/MLNX_OFED-5.8-3.0.7.0/MLNX_OFED_LINUX-5.8-3.0.7.0-ubuntu18.04-x86_64.iso \
        -O "$MLNX_OFED_IMG"
fi

## Setup env for cuda-ubuntu
export DIB_CUDA_URL=https://developer.download.nvidia.cn/compute/cuda/repos/ubuntu1804/x86_64/cuda-keyring_1.1-1_all.deb
export DIB_CUDA_VERSION=11.8.0-1

## Setup env for gpudirect-bench-ubuntu
export DIB_CUDA_PATH=/usr/local/cuda-11.8

## Setup env for cloud-init-datasources
export DIB_CLOUD_INIT_DATASOURCES="OpenStack"

export DIB_CONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"

disk-image-create --no-tmpfs \
    vm \
    dhcp-all-interfaces \
    cloud-init-datasources \
    mofed-ubuntu \
    cuda-ubuntu \
    gpudirect-bench-ubuntu \
    ubuntu \
    -o $ELEMENTS_PATH/ubuntu18.04-cuda11.8
