#!/bin/bash

JUPYTERLAB_VERSION=${JUPYTERLAB_VERSION:-"4.0.4"}
JUPYTERLAB_CONFIG=${HOME}/.jupyter/jupyter_lab_config.py
JUPYTERLAB_PORT=8888

setup_jupyterlab_binary() {
    if command -v jupyter &>/dev/null; then
        echo "jupyter already installed"
        return
    fi
    install_miniconda
    python3 -m pip install jupyterlab==${JUPYTERLAB_VERSION}
}

setup_jupyterlab_systemd() {
    # Check if jupyter lab systemd service is active
    if systemctl is-active --quiet jupyter-lab; then
        echo "Jupyter Lab systemd service is already active"
        return
    fi

    # Check if jupyter lab systemd service exists
    if [ -f /etc/systemd/system/jupyter-lab.service ]; then
        echo "jupyter lab systemd service already exists"
    else
        JUPYTER=$(which jupyter)
        cat <<EOF | sudo tee /etc/systemd/system/jupyter-lab.service
[Unit]
Description=Jupyter Lab

[Service]
Type=simple
PIDFile=/run/jupyter-lab.pid
ExecStart=${JUPYTER} lab --allow-root --config ${JUPYTERLAB_CONFIG}
User=${USER}
WorkingDirectory=${HOME}
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
    fi

    # Reload systemd and start jupyter lab service
    sudo systemctl daemon-reload
    sudo systemctl enable jupyter-lab
    sudo systemctl start jupyter-lab
}

setup_jupyterlab_config() {
    if [ -f ${JUPYTERLAB_CONFIG} ]; then
        echo "jupyter lab config already exists"
        return
    fi

    mkdir -p "$(dirname "${JUPYTERLAB_CONFIG}")"
    cat <<EOF >${JUPYTERLAB_CONFIG}
c = get_config()
c.ServerApp.ip = '0.0.0.0'
c.ServerApp.port = ${JUPYTERLAB_PORT}
c.LabApp.open_browser = False
c.ServerApp.root_dir = '${HOME}'
c.ServerApp.tornado_settings = {
    'headers': {
        'Content-Security-Policy': "frame-ancestors * 'self' "
    }
}
c.ServerApp.allow_remote_access = True
c.ServerApp.base_url = '/jupyter/'
c.ServerApp.allow_origin = '*'
EOF
}

install_jupyterlab() {
    setup_jupyterlab_binary
    setup_jupyterlab_config
    setup_jupyterlab_systemd
    echo "jupyter lab installed and added to systemd service."
}
