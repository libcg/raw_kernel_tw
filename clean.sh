#!/bin/bash

export CROSS_COMPILE=../raw_kernel/android-toolchain-eabi/bin/arm-linux-androideabi-
NCPU=$(cat /proc/cpuinfo | grep processor | wc -l)

make mrproper -j$NCPU
