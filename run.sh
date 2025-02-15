echo "Updating package lists..."
sudo apt update -y && sudo apt upgrade -y

# Daftar paket yang dibutuhkan
PACKAGES=(
  nano bc bison ca-certificates curl flex gcc git libc6-dev libssl-dev openssl
  python-is-python3 ssh wget zip zstd sudo make clang gcc-arm-linux-gnueabi
  software-properties-common build-essential libarchive-tools gcc-aarch64-linux-gnu
  libffi-dev libncurses5-dev zlib1g zlib1g-dev libreadline-dev libbz2-dev
  libsqlite3-dev pigz python2 python3 cpio lld llvm
)

# Cek dan install paket jika belum terinstal
for pkg in "${PACKAGES[@]}"; do
  if ! dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q "installed"; then
    echo "Installing $pkg..."
    sudo apt install -y "$pkg"
  else
    echo "$pkg is already installed, skipping..."
  fi
done

echo "All necessary packages are installed!"



read -p "Apakah ingin menggunakan KSU? : " confirm
if [ "${confirm}" = y ] || [ "${confirm}" = Y ]; then
read -p "Version : " versi
if [ -z "${versi}" ]; then
echo versi tidak boleh kosong! Diaggap tidak menggunakan ksu
else
curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -s v${versi}
fi
else
echo tidak menggunakan Ksu
fi


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

make --j$(nproc --all) ARCH=arm64 O=out \
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
