#!/bin/bash

MINICONDA_REPO=${MINICONDA_REPO:-"https://repo.anaconda.com/miniconda"}
MINICONDA_VERSION=${MINICONDA_VERSION:-"py311_23.5.2-0"}
MINICONDA_FILE=${MINICONDA_FILE:-"/tmp/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh"}

install_miniconda() {
    if command -v conda &>/dev/null; then
        return
    fi

    # Download Miniconda installer
    if [ ! -f "${MINICONDA_FILE}" ]; then
        wget -O "${MINICONDA_FILE}" "${MINICONDA_REPO}/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh"
    fi

    # Install Miniconda
    bash "${MINICONDA_FILE}" -b -p $HOME/miniconda

    # Add Miniconda to PATH
    echo 'export PATH="$HOME/miniconda/bin:$PATH"' >>$HOME/.bashrc
    source $HOME/.bashrc

    echo "miniconda3 ${MINICONDA_VERSION} installed"
}

cleanup_miniconda() {
    rm -rf "${MINICONDA_FILE}"
}
