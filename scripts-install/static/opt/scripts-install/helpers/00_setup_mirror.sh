#!/bin/bash

setup_pip_mirror() {
  mkdir -p ${HOME}/.pip
  cat >${HOME}/.pip/pip.conf <<EOF
[global]
index-url = https://mirrors.ustc.edu.cn/pypi/web/simple
EOF
  echo "pip mirror already set"
}

setup_conda_mirror() {
  cat >${HOME}/.condarc <<EOF
channels:
  - defaults
show_channel_urls: true
default_channels:
  - http://mirrors.ustc.edu.cn/anaconda/pkgs/main
  - http://mirrors.ustc.edu.cn/anaconda/pkgs/r
  - http://mirrors.ustc.edu.cn/anaconda/pkgs/msys2
custom_channels:
  conda-forge: http://mirrors.ustc.edu.cn/anaconda/cloud
  msys2: http://mirrors.ustc.edu.cn/anaconda/cloud
  bioconda: http://mirrors.ustc.edu.cn/anaconda/cloud
  menpo: http://mirrors.ustc.edu.cn/anaconda/cloud
  pytorch: http://mirrors.ustc.edu.cn/anaconda/cloud
  simpleitk: http://mirrors.ustc.edu.cn/anaconda/cloud
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
