#!/bin/bash

if [ ${DIB_DEBUG_TRACE:-0} -gt 0 ]; then
    set -x
fi
set -o errexit
set -o nounset
set -o pipefail

python3 << 'EOF'
import json
import os

config = {"mtu": 1450}

# Create /etc/docker directory if it doesn't exist
os.makedirs("/etc/docker", exist_ok=True)

# Try to read existing config if it exists
try:
    with open("/etc/docker/daemon.json", "r") as f:
        config.update(json.load(f))
except FileNotFoundError:
    pass

config["mtu"] = 1450

with open("/etc/docker/daemon.json", "w") as f:
    json.dump(config, f, indent=2)
EOF
