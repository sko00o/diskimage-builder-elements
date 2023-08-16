#!/bin/bash
set -euxo pipefail

NODE_EXPORTER_VERSION=${NODE_EXPORTER_VERSION:-"1.6.1"}
NODE_EXPORTER_URL=${NODE_EXPORTER_URL:-"https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz"}

setup_node_exporter_binary() {
    # Check if Node Exporter binary exists
    if command -v node_exporter &>/dev/null; then
        echo "Node Exporter binary already exists."
    else
        # Download Node Exporter
        wget ${NODE_EXPORTER_URL}

        # Extract Node Exporter
        tar -xzvf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz

        # Move Node Exporter binary
        sudo mv node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/node_exporter /usr/local/bin

        # Cleanup
        rm -rf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64
    fi
}

setup_node_exporter_systemd() {
    # Check if Node Exporter is already installed
    if systemctl is-active --quiet node_exporter.service; then
        echo "Node Exporter is already installed and active."
        return
    fi

    # Check if Node Exporter systemd service exists
    if [ -f /etc/systemd/system/node_exporter.service ]; then
        echo "Node Exporter systemd service already exists."
    else
        # Create user and group for Node Exporter
        sudo useradd --system node_exporter
        sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

        # Create systemd service
        cat <<EOF | sudo tee /etc/systemd/system/node_exporter.service
[Unit]
Description=Prometheus Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=default.target
EOF
    fi

    # Reload systemd and start Node Exporter service
    sudo systemctl daemon-reload
    sudo systemctl enable node_exporter
    sudo systemctl start node_exporter
}

install_node_exporter() {
    setup_node_exporter_binary
    setup_node_exporter_systemd
    echo "Node Exporter installed and added to systemd service."
}
