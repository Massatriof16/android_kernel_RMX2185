#!/bin/bash
sudo apt update -y && sudo apt upgrade -y && sudo apt install nano bc bison ca-certificates curl flex gcc git libc6-dev libssl-dev openssl python-is-python3 ssh wget zip zstd sudo make clang gcc-arm-linux-gnueabi software-properties-common build-essential libarchive-tools gcc-aarch64-linux-gnu -y && sudo apt install build-essential -y && sudo apt install libssl-dev libffi-dev libncurses5-dev zlib1g zlib1g-dev libreadline-dev libbz2-dev libsqlite3-dev make gcc -y && sudo apt install pigz -y && sudo apt install python2 -y && sudo apt install python3 -y && sudo apt install cpio -y && sudo apt install lld -y && sudo apt install llvm -y


git clone https://github.com/kdrag0n/aarch64-elf-gcc.git --depth=1
PATH=$PWD/aarch64-elf-gcc/bin:$PATH
CROSS_COMPILE=aarch64-elf-
make -j$(nproc --all) O=out ARCH=arm64 oppo6765_defconfig

# set environment variables
#git clone --depth=1 https://github.com/picasso09/proton-clang clang
KBUILD_BUILD_HOST="MS"
KBUILD_BUILD_USER="Massatrio16"
PATH="/usr/bin:$PATH"


# build kernel

make -j$(nproc --all) ARCH=arm64 O=out \
                      HOSTCC="clang" \
                      HOSTCXX="clang++" \
                      CC="clang" \
                      LD=ld.lld \
                      AR=llvm-ar \
                      NM=llvm-nm \
                      OBJCOPY=llvm-objcopy \
                      OBJDUMP=llvm-objdump \
                      READELF=llvm-readelf \
                      OBJSIZE=llvm-size \
                      STRIP=llvm-strip \
                      CROSS_COMPILE=aarch64-linux-gnu \
                      CROSS_COMPILE_ARM32=arm-linux-gnueabi-
                      
                      
                      
                      
curl -F document=@"out/arch/arm64/boot/Image.gz" https://api.telegram.org/bot7158353974:AAGsmJmfMHXIK9Pj2GIdo6u1eTH2HTR_HHQ/sendDocument?chat_id=6561499315

