#!/bin/bash
set -exo pipefail

cd "$(dirname "$0")"
source ./helpers/*.sh

install_cuda
install_node_exporter
install_miniconda
install_jupyterlab
install_tensorflow
