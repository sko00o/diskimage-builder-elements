# Install MinFS

You should run following scripts in cloud-init for s3 mount setup:

```sh
# set minfs config
cat <<EOF > /etc/minfs/config.json
{"version":"1","accessKey":"$S3_AK","secretKey":"$S3_SK"}
EOF

# create dir for mount
mkdir -p "${MOUNT_PATH}"

# mount s3 bucket
mount -t minfs -o ro,defaults,cache=/tmp/$S3_BUCKET "$S3_ENDPOINT/$S3_BUCKET" "${MOUNT_PATH}"
```
