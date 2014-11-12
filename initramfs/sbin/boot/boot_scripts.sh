#!/sbin/busybox sh
b="/sbin/busybox"
$b cp /data/local/tmp/user.log /data/local/tmp/user.log.bak
$b rm /data/local/tmp/user.log
exec >>/data/local/tmp/user.log
exec 2>&1
$b chmod 644 /data/local/tmp/user.log

# extract busybox to use instead of recovery busybox +/- install in bin/xbin
# /sbin/busybox sh /sbin/boot/busybox.sh

# set custom kernel properties to check kernel version if needed later
/sbin/busybox sh /sbin/boot/properties.sh

# for further tasks like adding root, extract busybox, Rom Manager...
/sbin/busybox sh /sbin/boot/install.sh

# starts init.d and customboot.sh scripts
/sbin/busybox sh /sbin/boot/init-scripts.sh