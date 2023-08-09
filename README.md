# diskimage-builder-elements

Some elements for [diskimage-builder (DIB)](https://docs.openstack.org/diskimage-builder/latest/) to build images.

## requirements

```sh
sudo apt-get update
sudo apt-get -y install kpartx debootstrap qemu-utils

# install miniconda and python
curl -o /tmp/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash /tmp/miniconda.sh -b -f -p /opt/miniconda
/opt/miniconda/bin/conda init
source ~/.bashrc

python3 -m pip install diskimage-builder
```

## build image

```sh
./build.sh etc/ubuntu18.04-miniconda3.yaml
```

Image file **ubuntu18.04-miniconda3.qcow2** will be grnerated.

## upload images to OpenStack

> Download "OpenStack RC File" from dashboard, save it as **service-openrc.sh**.

```sh
sudo apt-get -y install build-essential
python3 -m pip install python-openstackclient
source ./service-openrc.sh
openstack image create ubuntu18.04_miniconda3 --public --disk-format qcow2 --container-format bare --file ubuntu18.04-miniconda3.qcow2
```
