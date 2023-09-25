#!/bin/bash

PROMETHEUS_REPO=${PROMETHEUS_REPO:-"https://github.com/prometheus/prometheus/releases/download/"}
PROMETHEUS_VERSION=${PROMETHEUS_VERSION:-"2.37.9"}
PROMETHEUS_FILE=${PROMETHEUS_FILE:-"/tmp/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz"}
PROMETHEUS_EXTRACTED_DIR=${PROMETHEUS_EXTRACTED_DIR:-"/tmp/prometheus-${PROMETHEUS_VERSION}"}
PROMETHEUS_CONFIG=/etc/prometheus/prometheus.yml

setup_prometheus_binady() {
    # Check if prometheus binary exists
    if command -v prometheus &>/dev/null; then
        echo "prometheus binary already exists."
        return
    fi

    if [ ! -f "$PROMETHEUS_FILE" ]; then
        # Download prometheus
        wget -O "$PROMETHEUS_FILE" "${PROMETHEUS_REPO}/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz"
    fi

    # Extract prometheus
    mkdir -p "$PROMETHEUS_EXTRACTED_DIR"
    tar -xzvf "$PROMETHEUS_FILE" -C "$PROMETHEUS_EXTRACTED_DIR"

    # Move prometheus binary
    sudo mv ${PROMETHEUS_EXTRACTED_DIR}/prometheus-${PROMETHEUS_VERSION}.linux-amd64/prometheus /usr/local/bin
}

setup_prometheus_agent_systemd() {
    # Check if prometheus-agent systemd service is active
    if systemctl is-active --quiet prometheus-agent.service; then
        echo "prometheus-agent is already installed and active."
        return
    fi

    # Check if prometheus-agent systemd service exists
    if [ -f /etc/systemd/system/prometheus-agent.service ]; then
        echo "prometheus-agent systemd service already exists."
    else
        # Create systemd service
        cat <<EOF | sudo tee /etc/systemd/system/prometheus-agent.service
[Unit]
Description=Prometheus Agent
Wants=network-online.target
After=network-online.target

[Service]
User=root
Group=root
Type=simple
ExecStart=/usr/local/bin/prometheus --enable-feature=agent --config.file /etc/prometheus/prometheus.yml
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF
    fi

    # Enable prometheus-agent systemd service
    sudo systemctl daemon-reload
    sudo systemctl enable prometheus-agent.service
    sudo systemctl start prometheus-agent.service
}

setup_prometheus_config() {
    if [ -f ${PROMETHEUS_CONFIG} ]; then
        echo "prometheus config already exists"
        return
    fi

    mkdir -p "$(dirname "${PROMETHEUS_CONFIG}")"
    cat <<EOF >${PROMETHEUS_CONFIG}
global:
  scrape_interval: 5s
  external_labels:
    cluster: openstack
    replica: 0
scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]
  - job_name: "node_exporter"
    static_configs:
      - targets: ["localhost:9100"]
  - job_name: "dcgm-exporter"
    static_configs:
      - targets: ["localhost:9400"]
  - job_name: "nvidia_gpu_exporter"
    static_configs:
      - targets: ["localhost:9835"]
remote_write:
  - url: "http://prometheus.service.yoga:9094/api/v1/write"
EOF
}

install_prometheus_agent() {
    setup_prometheus_binady
    setup_prometheus_config
    setup_prometheus_agent_systemd
    echo "prometheus ${PROMETHEUS_VERSION} installed and added to systemd service"
}

cleanup_promehteus_agent() {
    rm -rf "${PROMETHEUS_FILE}" "${PROMETHEUS_EXTRACTED_DIR}"
}
