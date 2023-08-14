# Install qemu-guest-agent

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