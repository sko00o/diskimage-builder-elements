# diskimage-builder-elements

Some elements for [diskimage-builder (DIB)](https://docs.openstack.org/diskimage-builder/latest/) to build images.

## requirements

OS: Ubuntu 22.04

Create a vm for image building:

```sh
./vm.sh
```

After login in vm:

```sh
sudo su
cd /root/build/
```

## build image

```sh
./build.sh etc/image-gpu-mini.yaml
```

Image file **image-gpu-mini.qcow2** will be generated.

## upload images to OpenStack

> Download "OpenStack RC File" from dashboard, save it as **service-openrc.sh**.

```sh
sudo apt-get -y install build-essential
python3 -m pip install python-openstackclient
source ./service-openrc.sh

source ./upload-image
image-ubuntu image-gpu-mini
```
