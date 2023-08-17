#!/bin/bash
set -exo pipefail

CUDA_REPO="https://mirrors.aliyun.com/nvidia-cuda"
MINICONDA_REPO="https://mirrors.aliyun.com/anaconda/miniconda"

cd "$(dirname "$0")"
for helper in ./helpers/*.sh; do
    source "$helper"
done

setup_pip_mirror
setup_conda_mirror

install_cuda
install_node_exporter
install_miniconda
install_jupyterlab
install_tensorflow
install_pytorch
