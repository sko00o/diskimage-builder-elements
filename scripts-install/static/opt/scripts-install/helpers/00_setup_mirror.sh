#!/bin/bash

setup_pip_mirror() {
  mkdir -p ${HOME}/.pip
  cat >${HOME}/.pip/pip.conf <<EOF
[global]
index-url = http://mirrors.aliyun.com/pypi/simple/
[install]
trusted-host=mirrors.aliyun.com
EOF
  echo "pip mirror already set"
}

setup_conda_mirror() {
  cat >${HOME}/.condarc <<EOF
channels:
  - defaults
show_channel_urls: true
default_channels:
  - http://mirrors.aliyun.com/anaconda/pkgs/main
  - http://mirrors.aliyun.com/anaconda/pkgs/r
  - http://mirrors.aliyun.com/anaconda/pkgs/msys2
custom_channels:
  conda-forge: http://mirrors.aliyun.com/anaconda/cloud
  msys2: http://mirrors.aliyun.com/anaconda/cloud
  bioconda: http://mirrors.aliyun.com/anaconda/cloud
  menpo: http://mirrors.aliyun.com/anaconda/cloud
  pytorch: http://mirrors.aliyun.com/anaconda/cloud
  simpleitk: http://mirrors.aliyun.com/anaconda/cloud
EOF
  echo "conda mirror already set"
}

setup_docker_mirror() {
  mkdir -p /etc/docker
  if [ -f /etc/docker/daemon.json ]; then
    cp /etc/docker/daemon.json /etc/docker/daemon.json.bak
  fi
  cat >/etc/docker/daemon.json <<EOF
{
  "registry-mirrors": [
    "https://mirror.iscas.ac.cn",
    "https://mirror.ccs.tencentyun.com",
    "https://docker.nju.edu.cn",
    "http://hub-mirror.c.163.com",
    "https://docker.mirrors.ustc.edu.cn"
  ]
}
EOF
  if systemctl status docker >/dev/null 2>&1; then
    systemctl daemon-reload
    systemctl restart docker
  fi
  echo "docker mirror already set"
}
