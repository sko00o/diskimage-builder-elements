# Install qemu-guest-agent for ChinaMobileCloud Ubuntu images

Reference: https://ecloud.10086.cn/op-help-center/doc/article/23875#4426f6ed472834494a4acab4ebb3d281

You should set metadata `hw_qemu_guest_agent=yes` when upload image to OpenStack.

For example:

```sh
openstack image create \
  --property hw_qemu_guest_agent=yes \
  --container-format bare \
  --disk-format qcow2 \
  --public \
  --file ubuntu18.04-miniconda3.qcow2
  ubuntu18.04_miniconda3
```

If image already uploaded, you can set metadata by following command.

```
openstack image set --property hw_qemu_guest_agent=yes <IMAGE_ID>
```