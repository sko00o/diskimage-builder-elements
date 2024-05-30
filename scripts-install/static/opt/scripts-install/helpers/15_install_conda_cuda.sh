#!/bin/bash

CUDATOOLKIT_VERSION=${CUDATOOLKIT_VERSION:-"11.8.0"}
CUDNN_CU11_VERSION=${CUDNN_CU11_VERSION:-"8.6.0.163"}

conda_install_cuda() {
    ## Install CUDA
    conda install -y cudatoolkit=${CUDATOOLKIT_VERSION}
}

pip_install_cudnn() {
    CONDA_PREFIX=$(conda info --base)
    ## Install cuDNN
    python3 -m pip install nvidia-cudnn-cu11==${CUDNN_CU11_VERSION}

    ## Setup cuDNN
    mkdir -p $CONDA_PREFIX/etc/conda/activate.d
    echo 'CUDNN_PATH=$(dirname $(python -c "import nvidia.cudnn;print(nvidia.cudnn.__file__)"))' >>$CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
    echo 'export LD_LIBRARY_PATH=$CONDA_PREFIX/lib/:$CUDNN_PATH/lib:$LD_LIBRARY_PATH' >>$CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
}

install_conda_cuda() {
    install_miniconda
    conda_install_cuda
    pip_install_cudnn
}