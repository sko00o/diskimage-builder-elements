#!/bin/bash

setup_disk_partition() {
    device="$1"
    partition="${device}1"

    # check if partition exists
    if lsblk -rno NAME "$partition" >/dev/null 2>&1; then
        echo "partition $partition exist"
        return
    fi

    # create partition and format to ext4
    echo "partition $partition not exist, will format $device"
    echo -e "n\np\n1\n\n\nw" | fdisk "$device"
    mkfs.ext4 "$partition"
}

systemd_mount_partition() {
    partition="$1"
    mount_point="$2"

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
