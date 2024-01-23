#!/bin/bash

PYTORCH_VERSION=${PYTORCH_VERSION:-"2.0.1"}
PYTORCH_TORCHVISION_VERSION=${PYTORCH_TORCHVISION_VERSION:-"0.15.2"}
PYTORCH_TORCHAUDIO_VERSION=${PYTORCH_TORCHAUDIO_VERSION:-"2.0.2"}
PYTORCH_CUDA_VERSION=${PYTORCH_CUDA_VERSION:-"11.8"}
PYTORCH_LINKS=${PYTORCH_LINKS:-"/root/public/whl/"}

install_pytorch_conda() {
    conda install -y -c pytorch -c nvidia \
        pytorch==${PYTORCH_VERSION} \
        torchvision==${PYTORCH_TORCHVISION_VERSION} \
        torchaudio==${PYTORCH_TORCHAUDIO_VERSION} \
        pytorch-cuda=${PYTORCH_CUDA_VERSION}
}

install_pytorch_pip() {
    extra="cu${PYTORCH_CUDA_VERSION//./}"
    python3 -m pip install \
        torch==${PYTORCH_VERSION}+${extra} \
        torchvision==${PYTORCH_TORCHVISION_VERSION}+${extra} \
        torchaudio==${PYTORCH_TORCHAUDIO_VERSION} \
        --index-url https://download.pytorch.org/whl/${extra}
}

install_pytorch_pip_offline() {
    extra="cu${PYTORCH_CUDA_VERSION//./}"
    python3 -m pip install \
        torch==${PYTORCH_VERSION}+${extra} \
        torchvision==${PYTORCH_TORCHVISION_VERSION}+${extra} \
        torchaudio==${PYTORCH_TORCHAUDIO_VERSION} \
        --no-index --find-links "${PYTORCH_LINKS}"
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

    # Try offline installation first
    if [[ -n "${PYTORCH_LINKS}" ]]; then
        echo "Installing pytorch ${PYTORCH_VERSION} from ${PYTORCH_LINKS}"
        if install_pytorch_pip_offline; then
            echo "pytorch ${PYTORCH_VERSION} installed"
            return
        fi
    fi

    echo "Installing pytorch ${PYTORCH_VERSION} from pip"
    install_pytorch_pip
    echo "pytorch ${PYTORCH_VERSION} installed"
}
