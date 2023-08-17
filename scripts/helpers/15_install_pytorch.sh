#!/bin/bash

PYTORCH_VERSION=${PYTORCH_VERSION:-"2.0.1"}
PYTORCH_TORCHVISION_VERSION=${PYTORCH_TORCHVISION_VERSION:-"0.15.2"}
PYTORCH_TORCHAUDIO_VERSION=${PYTORCH_TORCHAUDIO_VERSION:-"2.0.2"}
PYTORCH_CUDA_VERSION=${PYTORCH_CUDA_VERSION:-"11.8"}

install_pytorch_conda() {
    conda install -y -c pytorch -c nvidia \
        pytorch==${PYTORCH_VERSION} \
        torchvision==${PYTORCH_TORCHVISION_VERSION} \
        torchaudio==${PYTORCH_TORCHAUDIO_VERSION} \
        pytorch-cuda=${PYTORCH_CUDA_VERSION}
}

install_pytorch_pip() {
    extra=${PYTORCH_CUDA_VERSION//./}
    python3 -m pip install \
        torch==${PYTORCH_VERSION}+${extra} \
        torchvision==${PYTORCH_TORCHVISION_VERSION}+${extra} \
        torchaudio==${PYTORCH_TORCHAUDIO_VERSION} \
        --index-url https://download.pytorch.org/whl/${extra}
}

verify_pytorch() {
    python3 -c "import torch; print(torch.__version__)"
}

install_pytorch() {
    install_miniconda

    # If verify successfully, skip installation
    if verify_pytorch; then
        return
    fi

    install_pytorch_conda
}
