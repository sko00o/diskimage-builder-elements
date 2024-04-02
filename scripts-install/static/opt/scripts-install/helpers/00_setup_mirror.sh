#!/bin/bash

setup_pip_mirror() {
  mkdir -p ${HOME}/.pip
  cat >${HOME}/.pip/pip.conf <<EOF
[global]
index-url = https://mirrors.bfsu.edu.cn/pypi/web/simple
EOF
  echo "pip mirror already set"
}

setup_conda_mirror() {
  cat >${HOME}/.condarc <<EOF
channels:
  - defaults
show_channel_urls: true
default_channels:
  - https://mirrors.bfsu.edu.cn/anaconda/pkgs/main
  - https://mirrors.bfsu.edu.cn/anaconda/pkgs/r
  - https://mirrors.bfsu.edu.cn/anaconda/pkgs/msys2
custom_channels:
  conda-forge: https://mirrors.bfsu.edu.cn/anaconda/cloud
  msys2: https://mirrors.bfsu.edu.cn/anaconda/cloud
  bioconda: https://mirrors.bfsu.edu.cn/anaconda/cloud
  menpo: https://mirrors.bfsu.edu.cn/anaconda/cloud
  pytorch: https://mirrors.bfsu.edu.cn/anaconda/cloud
  pytorch-lts: https://mirrors.bfsu.edu.cn/anaconda/cloud
  simpleitk: https://mirrors.bfsu.edu.cn/anaconda/cloud
  deepmodeling: https://mirrors.bfsu.edu.cn/anaconda/cloud/
EOF
  echo "conda mirror already set"
}

setup_docker_mirror() {
  sudo mkdir -p /etc/docker
  if [ -f /etc/docker/daemon.json ]; then
    sudo cp /etc/docker/daemon.json /etc/docker/daemon.json.bak
  fi
  sudo cat >/etc/docker/daemon.json <<EOF
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
  if sudo systemctl status docker >/dev/null 2>&1; then
    sudo systemctl daemon-reload
    sudo systemctl restart docker
  fi
  echo "docker mirror already set"
}
