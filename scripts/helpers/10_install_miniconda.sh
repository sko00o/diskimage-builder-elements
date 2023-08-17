#!/bin/bash

MINICONDA_REPO=${MINICONDA_REPO:-"https://repo.anaconda.com/miniconda"}
MINICONDA_VERSION=${MINICONDA_VERSION:-"py311_23.5.2-0"}

install_miniconda() {
    if command -v conda &>/dev/null; then
        return
    fi

    # Download Miniconda installer
    filename="Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh"
    wget -O ${filename} "${MINICONDA_REPO}/${filename}"

    # Install Miniconda
    bash ${filename} -b -p $HOME/miniconda

    # Add Miniconda to PATH
    echo 'export PATH="$HOME/miniconda/bin:$PATH"' >>$HOME/.bashrc
    source $HOME/.bashrc

    # Cleanup
    rm ${filename}

    echo "miniconda3 ${MINICONDA_VERSION} installed"
}
