#!/bin/bash

setup_disk_partition() {
    device="$1"
    partition="${device}1"

    # check if partition exists
    if lsblk -rno NAME "$partition" >/dev/null 2>&1; then
        echo "partition $partition exist"
        return
    fi

    # create partition
    echo "partition $partition not exist, creating..."
    # Using parted instead of fdisk for more than 2TB partition
    #   mklabel label-type
    #   mkpart [part-type name fs-type] start end
    parted --align optimal --script "$device" -- mklabel gpt mkpart primary ext4 0% 100%

    # Wait for partition to be created
    while ! lsblk -rno NAME "$partition" >/dev/null 2>&1; do
        sleep 1
    done
    echo "partition $partition created"
}

systemd_mount_partition() {
    partition="$1"
    mount_point="$2"

    # check if partition is ext4 format
    while ! blkid -s TYPE -o value "$partition" | grep -q ext4; do
        if ! mkfs.ext4 "$partition"; then
            sleep 1
            continue
        fi
        echo "format $partition to ext4 success"
    done

    # e.g. mount_point=/disk/sdb1 -> filename=disk-sdb1.mount
    filename="${mount_point//\//-}"
    filename="${filename#-}"

    # create mount point directory
    mkdir -p "$mount_point"

    # create systemd mount unit file
    cat <<EOF >"/etc/systemd/system/${filename}.mount"
[Unit]
Description=Mount disk $partition to $mount_point
[Mount]
What=$partition
Where=$mount_point
Type=ext4
Options=defaults
EOF
    # create systemd automount unit file
    cat >/etc/systemd/system/${filename}.automount <<EOF
[Unit]
Description=Auto mount $mount_point
Requires=cloud-init.target
[Automount]
Where=$mount_point
[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    systemctl disable "${filename}.mount"
    systemctl enable "${filename}.automount"
    # if .automount not start and .mount is started
    if ! systemctl is-active --quiet "${filename}.automount" && systemctl is-active --quiet "${filename}.mount"; then
        systemctl stop "${filename}.mount"
    fi
    systemctl start "${filename}.automount"
    echo "mount $partition to $mount_point success"
}

trigger_mount_service() {
    mount_point="$1"

    # e.g. mount_point=/disk/sdb1 -> filename=disk-sdb1.mount
    filename="${mount_point//\//-}"
    filename="${filename#-}"

    # exec stat once on $mount_point
    # this must exec after cloud-init.target
    cat >/etc/systemd/system/${filename}.service <<EOF
[Unit]
Description=trigger mount $mount_point
After=cloud-final.service
[Service]
Type=oneshot
ExecStart=stat $mount_point
[Install]
WantedBy=cloud-init.target
EOF

    systemctl enable --now "${filename}.service"
    echo "trigger mount $mount_point success"
}
