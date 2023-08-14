#!/bin/bash

if [ ${DIB_DEBUG_TRACE:-0} -gt 0 ]; then
    set -x
fi
set -o errexit
set -o nounset
set -o pipefail

# Setup customized motd
cat <<EOF >/etc/motd
Welcome!
EOF

# Disable default motd
chmod -x /etc/update-motd.d/*
