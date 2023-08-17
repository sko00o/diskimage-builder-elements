#!/bin/bash
set -exo pipefail

cd "$(dirname "$0")"
for helper in ./helpers/*.sh; do
    source "$helper"
done

install_cuda
install_node_exporter
install_miniconda
install_jupyterlab
install_tensorflow
install_pytorch
