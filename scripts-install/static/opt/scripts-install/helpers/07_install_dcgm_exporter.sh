#!/bin/bash

DCGM_EXPORTER_VERSION=${DCGM_EXPORTER_VERSION:-"3.1.8-3.1.5"}
DCGM_EXPORTER_REPO=${DCGM_EXPORTER_REPO:-"https://github.com/NVIDIA/dcgm-exporter.git"}
DCGM_EXPORTER_BUILD_DIR=${DCGM_EXPORTER_BUILD_DIR:-"/tmp/dcgm-exporter"}

setup_dcgm_exporter_systemd() {
    if systemctl is-active --quiet dcgm-exporter; then
        echo "dcgm-exporter is already installed and active."
        return
    fi

    # Check if dcgm-exporter systemd service exists
    if [ -f /etc/systemd/system/dcgm-exporter.service ]; then
        echo "dcgm-exporter systemd service already exists."
    else
        # Create an user for dcgm-exporter
        useradd --no-create-home --shell /bin/false dcgm-exporter
        chown dcgm-exporter:dcgm-exporter /usr/local/bin/dcgm-exporter

        # Create systemd service
        sudo tee /etc/systemd/system/dcgm-exporter.service <<EOF
[Unit]
Description=DCGM Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=dcgm-exporter
Group=dcgm-exporter
Type=simple
ExecStart=/usr/local/bin/dcgm-exporter
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF
    fi

    sudo systemd daemon-reload
    sudo systemctl enable dcgm-exporter.service
    sudo systemctl start dcgm-exporter.service
}

setup_dcgm_exporter_binary() {
    if command -v dcgm-exporter &>/dev/null; then
        return
    fi
    install_go
    sudo apt-get -y install build-essential
    git clone -b "${DCGM_EXPORTER_VERSION}" "$DCGM_EXPORTER_REPO" "$DCGM_EXPORTER_BUILD_DIR"
    cd "$DCGM_EXPORTER_BUILD_DIR"
    make binary
    make install
}

install_dcgm_exporter() {
    setup_dcgm_exporter_binary
    setup_dcgm_exporter_systemd
    echo "dcgm-exporter ${DCGM_EXPORTER_VERSION} installed successfully."
}

cleanup_dcgm_exporter() {
    cleanup_go
    uninstall_go
    rm -rf "$DCGM_EXPORTER_BUILD_DIR"
}
