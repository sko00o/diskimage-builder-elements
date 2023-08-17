#!/bin/bash
set -euxo pipefail

JUPYTERLAB_VERSION=${JUPYTERLAB_VERSION:-"4.0.4"}

install_jupyterlab() {
    install_miniconda
    conda install -y -c conda-forge jupyterlab=${JUPYTERLAB_VERSION}
}

install_jupyterlab
