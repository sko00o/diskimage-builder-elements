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

    # e.g. mount_point=/disk/sdb1 -> unit_file=disk-sdb1.mount
    unit_file="${mount_point//\//-}.mount"
    unit_file="${unit_file#-}"
    systemd_file="/etc/systemd/system/${unit_file}"

    # create mount point directory
    mkdir -p "$mount_point"

    # create systemd mount unit file
    cat <<EOF >"$systemd_file"
[Unit]
Description=Mount disk $partition to $mount_point
[Mount]
What=$partition
Where=$mount_point
Type=ext4
Options=defaults
[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    systemctl enable "${unit_file}"
    systemctl start "${unit_file}"
    echo "mount $partition to $mount_point success"
}
