# Install s3fs

https://github.com/s3fs-fuse/s3fs-fuse

```sh
# set s3fs config
echo "$S3_AK:$S3_SK" > /etc/passwd-s3fs
chmod 600 /etc/passwd-s3fs

# create dir for mount
mkdir -p "${MOUNT_PATH}"

# mount s3 bucket
s3fs "${S3_BUCKET}" "${MOUNT_PATH}" -o url="$S3_ENDPOINT" -o use_path_request_style -o ro
# or
# mount -t fuse.s3fs -o ro,defaults,use_path_request_style,url="$S3_ENDPOINT" "${S3_BUCKET}" "${MOUNT_PATH}"
```