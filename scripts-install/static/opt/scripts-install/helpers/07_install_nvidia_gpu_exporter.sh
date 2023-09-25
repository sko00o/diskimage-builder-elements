#!/bin/bash

NVIDIA_GPU_EXPORTER_REPO=${NVIDIA_GPU_EXPORTER_REPO:-"https://github.com/utkuozdemir/nvidia_gpu_exporter/releases/download"}
NVIDIA_GPU_EXPORTER_VERSION=${NVIDIA_GPU_EXPORTER_VERSION:-"1.2.0"}
NVIDIA_GPU_EXPORTER_FILE=${NVIDIA_GPU_EXPORTER_FILE:-"/tmp/nvidia_gpu_exporter-${NVIDIA_GPU_EXPORTER_VERSION}.linux-amd64.tar.gz"}
NVIDIA_GPU_EXPORTER_EXTRACTED_DIR=${NVIDIA_GPU_EXPORTER_EXTRACTED_DIR:-"/tmp/nvidia_gpu_exporter-${NVIDIA_GPU_EXPORTER_VERSION}"}

setup_nvidia_gpu_exporter_binary() {
    # Check if nvidia_gpu_exporter binary exists
    if command -v nvidia_gpu_exporter &>/dev/null; then
        echo "nvidia_gpu_exporter binary already exists."
        return
    fi

    if [ ! -f "${NVIDIA_GPU_EXPORTER_FILE}" ]; then
        # Download nvidia_gpu_exporter
        wget -O "${NVIDIA_GPU_EXPORTER_FILE}" "${NVIDIA_GPU_EXPORTER_REPO}/v${NVIDIA_GPU_EXPORTER_VERSION}/nvidia_gpu_exporter-${NVIDIA_GPU_EXPORTER_VERSION}.linux-amd64.tar.gz"
    fi

    # Extract nvidia_gpu_exporter
    mkdir -p "${NVIDIA_GPU_EXPORTER_EXTRACTED_DIR}"
    tar -xzvf "${NVIDIA_GPU_EXPORTER_FILE}" -C "${NVIDIA_GPU_EXPORTER_EXTRACTED_DIR}"

    # Move nvidia_gpu_exporter binary
    sudo mv ${NVIDIA_GPU_EXPORTER_EXTRACTED_DIR}/nvidia_gpu_exporter-${NVIDIA_GPU_EXPORTER_VERSION}.linux-amd64/nvidia_gpu_exporter /usr/local/bin
}

setup_nvidia_gpu_exporter_systemd() {
    # Check if nvidia_gpu_exporter systemd service is active
    if systemctl is-active --quiet nvidia_gpu_exporter.service; then
        echo "nvidia_gpu_exporter is already installed and active."
        return
    fi

    # Check if nvidia_gpu_exporter systemd service exists
    if [ -f /etc/systemd/system/nvidia_gpu_exporter.service ]; then
        echo "nvidia_gpu_exporter systemd service already exists."
    else
        # Create user and group for nvidia_gpu_exporter
        sudo useradd --system nvidia_gpu_exporter
        sudo chown nvidia_gpu_exporter:nvidia_gpu_exporter /usr/local/bin/nvidia_gpu_exporter

        # Create systemd service
        cat <<EOF | sudo tee /etc/systemd/system/nvidia_gpu_exporter.service
[Unit]
Description=Prometheus Nvidia GPU Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=nvidia_gpu_exporter
Group=nvidia_gpu_exporter
Type=simple
ExecStart=/usr/local/bin/nvidia_gpu_exporter

[Install]
WantedBy=default.target
EOF
    fi

    # Enable and start nvidia_gpu_exporter systemd service
    sudo systemctl daemon-reload
    sudo systemctl enable nvidia_gpu_exporter
    sudo systemctl start nvidia_gpu_exporter
}

install_nvidia_gpu_exporter() {
    setup_nvidia_gpu_exporter_binary
    setup_nvidia_gpu_exporter_systemd
    echo "nvidia_gpu_exporter ${NVIDIA_GPU_EXPORTER_VERSION} installed and added to systemd service"
}

cleanup_nvidia_gpu_exporter() {
    rm -rf "${NVIDIA_GPU_EXPORTER_FILE}" "${NVIDIA_GPU_EXPORTER_EXTRACTED_DIR}"
}