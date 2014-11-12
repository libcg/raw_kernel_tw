#!/sbin/busybox sh

b="/sbin/busybox"

# Remount system RW
    $b mount -o remount,rw /system
    $b mount -t rootfs -o remount,rw rootfs

# Android Logger enable tweak
if [ "`$b grep ANDROIDLOGGER /system/etc/tweaks.conf`" ]; then
  $b insmod /lib/modules/logger.ko
fi

#max cpu freq
if [ -f /data/c.o.h./scaling_max_freq ]
then
 cat /data/c.o.h./scaling_max_freq > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
else
 cd /data
 toolbox mkdir c.o.h.
 toolbox chmod 777 /data/c.o.h.
 echo 1400000 > /data/c.o.h./scaling_max_freq
 toolbox chmod 777 /data/c.o.h./scaling_max_freq
 cat /data/c.o.h./scaling_max_freq > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
fi
echo "Complete! max cpu freq";

#min cpu freq
if [ -f /data/c.o.h./scaling_min_freq ]
then
 cat /data/c.o.h./scaling_min_freq > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
else
 echo 200000 > /data/c.o.h./scaling_min_freq
 toolbox chmod 777 /data/c.o.h./scaling_min_freq
 cat /data/c.o.h./scaling_min_freq > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
fi
echo "Complete! min cpu freq";

#cpu governor
if [ -f /data/c.o.h./scaling_governor ]
then
 cat /data/c.o.h./scaling_governor > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
else
 echo "pegasusq" > /data/c.o.h./scaling_governor
 toolbox chmod 777 /data/c.o.h./scaling_governor
 cat /data/c.o.h./scaling_governor > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
fi
echo "Complete! change governor";

#I/O sheduler
if [ -f /data/c.o.h./scheduler ]
then
 echo "user settings exist";
else
 echo "noop" > /data/c.o.h./scheduler
 toolbox chmod 777 /data/c.o.h./scheduler
 echo "create default user settings";
fi
sched=`$b cat /data/c.o.h./scheduler`
for i in mmcblk0 mmcblk1
do
        echo "Changing I/O Scheduler to $sched for block ${i}";
        echo $sched > /sys/block/${i}/queue/scheduler;
        cat /sys/block/${i}/queue/scheduler;
done
echo "Complete! change I/O sheduler to $sched";

boot_extract()
{
	eval $(/sbin/read_boot_headers /dev/block/mmcblk0p5)
	load_offset=$boot_offset
	load_len=$boot_len
	$b dd bs=512 if=/dev/block/mmcblk0p5 skip=$load_offset count=$load_len | $b xzcat | $b tar x
	payload=1
}

installs()
{
#	Install RomManager
	$b rm /system/app/com.koushikdutta.rommanager*.apk
	$b rm /system/app/RomManager.apk
	$b rm /data/dalvik-cache/*com.koushikdutta.rommanager*
	$b rm /data/app/com.koushikdutta.rommanager*.apk
	$b zcat /cache/misc/RomManager.apk.gz > /system/app/RomManager.apk
	$b chown 0.0 /system/app/RomManager.apk
	$b chmod 644 /system/app/RomManager.apk
}

# Once be enough
    toolbox mkdir /system/cfroot
    toolbox chmod 755 /system/cfroot
    toolbox rm /data/cfroot/*
    toolbox rmdir /data/cfroot
    toolbox rm /system/cfroot/*
    echo 1 > /system/cfroot/release-124-LPG- 

# FM radio module
insmod /lib/modules/Si4709_driver.ko

# Remount system RO
    $b mount -t rootfs -o remount,ro rootfs
    $b mount -o remount,ro /system
