#!/bin/bash

MINICONDA_VERSION=${MINICONDA_VERSION:-"latest"}
MINICONDA_URL=${MINICONDA_URL:-"https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh"}

install_miniconda() {
    if command -v conda &>/dev/null; then
        return
    fi

    # Download Miniconda installer
    wget "${MINICONDA_URL}"

    # Install Miniconda
    bash Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -b -p $HOME/miniconda

    # Add Miniconda to PATH
    echo 'export PATH="$HOME/miniconda/bin:$PATH"' >>$HOME/.bashrc
    source $HOME/.bashrc

    # Cleanup
    rm Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh
}
