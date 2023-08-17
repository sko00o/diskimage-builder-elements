#!/bin/bash

PYTORCH_VERSION=${PYTORCH_VERSION:-"2.0.1"}
PYTORCH_TORCHVISION_VERSION=${PYTORCH_TORCHVISION_VERSION:-"0.15.2"}
PYTORCH_TORCHAUDIO_VERSION=${PYTORCH_TORCHAUDIO_VERSION:-"2.0.2"}
PYTORCH_CUDA_VERSION=${PYTORCH_CUDA_VERSION:-"11.8"}

install_pytorch_conda() {
    install_miniconda
    conda install -y -c pytorch -c nvidia \
        pytorch==${PYTORCH_VERSION} \
        torchvision==${PYTORCH_TORCHVISION_VERSION} \
        torchaudio==${PYTORCH_TORCHAUDIO_VERSION} \
        pytorch-cuda=${PYTORCH_CUDA_VERSION}
}

install_pytorch_pip() {
    install_miniconda
    extra=${PYTORCH_CUDA_VERSION//./}
    pip3 install \
        torch==${PYTORCH_VERSION}+${extra} \
        torchvision==${PYTORCH_TORCHVISION_VERSION}+${extra} \
        torchaudio==${PYTORCH_TORCHAUDIO_VERSION} \
        --index-url https://download.pytorch.org/whl/${extra}
}

install_pytorch() {
    install_pytorch_conda
}
