#!/bin/bash

MINICONDA_REPO=${MINICONDA_REPO:-"https://repo.anaconda.com/miniconda"}
MINICONDA_VERSION=${MINICONDA_VERSION:-"latest"}

install_miniconda() {
    if command -v conda &>/dev/null; then
        return
    fi

    # Download Miniconda installer
    wget "${MINICONDA_REPO}/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh"

    # Install Miniconda
    bash Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -b -p $HOME/miniconda

    # Add Miniconda to PATH
    echo 'export PATH="$HOME/miniconda/bin:$PATH"' >>$HOME/.bashrc
    source $HOME/.bashrc

    # Cleanup
    rm Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh
}
