#!/bin/bash

NCPU=$(cat /proc/cpuinfo | grep processor | wc -l)

cp arch/arm/configs/q1_defconfig_aosp .config

make -j$NCPU && \
mkdir -p out/system/lib/modules && \
rm -f out/system/lib/modules/* && \
cp $(find . -name *.ko) out/system/lib/modules && \
cp arch/arm/boot/zImage out/boot.img
