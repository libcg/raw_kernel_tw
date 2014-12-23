#!/bin/bash

export CROSS_COMPILE=../raw_kernel/android-toolchain-eabi/bin/arm-linux-androideabi-
NCPU=$(cat /proc/cpuinfo | grep processor | wc -l)

cp arch/arm/configs/q1_speedmod_defconfig_raw .config

make modules -j$NCPU
mkdir -p initramfs/lib/modules/
rm -f initramfs/lib/modules/*
cp $(find . -name *.ko) initramfs/lib/modules/

make -j$NCPU
