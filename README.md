# diskimage-builder-elements

Some elements for [diskimage-builder (DIB)](https://docs.openstack.org/diskimage-builder/latest/) to build images.

## requirements

<details>
<summary> Install python3 if it's not exists. </summary>

DO NOT USE CONDA ON BUILD HOST!
Environment variables related to conda may lead to image build fail.

I recommended install python3.10. You can build it from source on Ubuntu18.04.

```sh
sudo apt-get -y install build-essential wget \
    libbz2-dev zlib1g-dev libncurses-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev

wget https://www.python.org/ftp/python/3.10.12/Python-3.10.12.tar.xz
tar -xf Python-3.10.12.tar.xz
cd Python-3.10.12
./configure --enable-optimizations
make -j $(nproc)
sudo make install

## enter venv
python3 -m venv venv
source venv/bin/activate
```
</details>


```sh
sudo apt-get update
sudo apt-get -y install kpartx debootstrap qemu-utils
python3 -m pip install diskimage-builder
```

## build image

```sh
./build.sh etc/image-mini.yaml
```

Image file **image-mini.qcow2** will be generated.

## upload images to OpenStack

> Download "OpenStack RC File" from dashboard, save it as **service-openrc.sh**.

```sh
sudo apt-get -y install build-essential
python3 -m pip install python-openstackclient
source ./service-openrc.sh

openstack image create \
  --container-format bare \
  --disk-format qcow2 \
  --public \
  --file image-mini.qcow2
  ubuntu18.04_miniconda3
```
