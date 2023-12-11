#!/bin/bash

private_bucket_set_config() {
    local s3_ak="$1"
    local s3_sk="$2"
    local s3_endpoint="$3"
    local s3_bucket="$4"
    local rclone_config_file="${5:-"/root/.config/rclone/rclone.conf"}"
    
    # call python heredoc to set ini config
    /bin/python3 <<EOF
import argparse
import configparser
cfg_path = "$rclone_config_file"
config = configparser.ConfigParser()
with open(cfg_path, 'r') as file:
    config.read_file(file)
cfg_name = "cfg-$s3_bucket"
config[cfg_name] = {
    "type": "s3",
    "env_auth": "false",
    "provider": "Other",
    "access_key_id": "$s3_ak",
    "secret_access_key": "$s3_sk",
    "endpoint": "$s3_endpoint",
}
with open(cfg_path, 'w') as file:
    config.write(file)
print(f"Updated rclone configuration: {cfg_path} [{cfg_name}]")
EOF
}

private_bucket_setup_systemd() {
    # check systemd service file exists
    local rclone_service_file="/etc/systemd/system/mount-private@.service"
    if [[ -f "$rclone_service_file" ]]; then
        echo "$rclone_service_file exists."
    fi

    # create systemd service file
    cat <<EOF | sudo tee "$rclone_service_file"
[Unit]
Description=rclone: Remote FUSE filesystem for private data
Documentation=man:rclone(1)
After=network-online.target
Wants=network-online.target

[Service]
Type=notify
User=root
Group=root
ExecStartPre=-/bin/mkdir -p /root/private
ExecStart= \
  /usr/bin/rclone mount \
    --config=/root/.config/rclone/rclone.conf \
    --allow-other \
    cfg-%i:%i /root/private
ExecStop=/bin/fusermount -u /root/private

[Install]
WantedBy=default.target
EOF
}

private_bucket_clout_init() {
    private_bucket_setup_systemd
    systemctl daemon-reload
    private_bucket_set_config "$1" "$2" "$3" "$4"
    systemctl enable --now mount-private@${4}.service
}
