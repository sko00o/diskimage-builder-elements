#!/bin/bash

# https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository

DOCKER_REPO=${DOCKER_REPO:-"https://download.docker.com/linux/ubuntu"}
DOCKER_VERSION=${DOCKER_VERSION:-"24.0.0"}

setup_docker_repo() {
    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL "${DOCKER_REPO}/gpg" |
        sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    # Add the repository to Apt sources:
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] ${DOCKER_REPO} \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
        sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    sudo apt-get update
}

install_docker_ce() {
    # Install Docker CE
    VERSION_STRING="5:${DIB_DOCKER_VERSION}-1~ubuntu.$(lsb_release -rs)~$(lsb_release -cs)"

    sudo apt-get install -y docker-ce=$VERSION_STRING \
        docker-ce-cli=$VERSION_STRING \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin
}

install_docker() {
    if command -v docker >/dev/null 2>&1; then
        echo "docker already installed"
        return
    fi

    setup_docker_repo
    install_docker_ce
}
