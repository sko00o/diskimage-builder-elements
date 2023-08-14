#!/bin/bash

if [ ${DIB_DEBUG_TRACE:-0} -gt 0 ]; then
    set -x
fi
set -o errexit
set -o nounset
set -o pipefail

echo "############################################################"
echo "# ssh permit root login                                    #"
echo "############################################################"

cat >/etc/cloud/cloud.cfg.d/06-dib-root-pwauth.cfg <<EOF
runcmd:
  - echo 'Include /etc/ssh/sshd_config.d/*.conf' >> /etc/ssh/sshd_config
write_files:
  - path: /etc/ssh/sshd_config.d/permit_root_login.conf
    content: |
      PermitRootLogin yes
EOF
