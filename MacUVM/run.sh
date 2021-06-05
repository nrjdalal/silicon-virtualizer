if [ ! -d ./machine-lts/ ]; then
  mkdir ./machine-lts/
fi

if [ -f ./machine-lts/ubuntu-lts.iso ]; then
  echo "$(tput setaf 3)image exists.$(tput sgr0)"
else
  echo "$(tput setaf 3)downloading image.$(tput sgr0)"
  curl https://cdimage.ubuntu.com/releases/20.04/release/ubuntu-20.04.2-live-server-arm64.iso -o ./machine-lts/ubuntu-lts.iso
fi

if [ -f ./machine-lts/edk2-aarch64-code.fd ]; then
  echo "$(tput setaf 3)edk2 exists.$(tput sgr0)"
else
  echo "$(tput setaf 3)copying edk2.$(tput sgr0)"
  cp $(dirname $(which qemu-img))/../share/qemu/edk2-aarch64-code.fd ./machine-lts/
fi

if [ -f ./machine-lts/virtual-disk.qcow2 ]; then
  echo "$(tput setaf 3)virtual-disk exists.$(tput sgr0)"
else
  echo "$(tput setaf 3)creating virtual-disk.$(tput sgr0)"
  qemu-img create -f qcow2 ./machine-lts/virtual-disk.qcow2 8G
fi

if [ -f ./machine-lts/ovmf_vars.fd ]; then
  echo "$(tput setaf 3)ovmf exists.$(tput sgr0)"
else
  echo "$(tput setaf 3)creating ovmf.$(tput sgr0)"
  dd if=/dev/zero conv=sync bs=1m count=64 of=./machine-lts/ovmf_vars.fd
fi

if [ ! -f ./machine-lts/initialized.txt ]; then

  echo "$(tput setaf 6)qemu started. close manually after first reboot.$(tput sgr0)"

  qemu-system-aarch64 \
    -machine virt,accel=hvf,highmem=off \
    -cpu cortex-a72 -smp 4 -m 4G \
    -device virtio-gpu-pci \
    -device virtio-keyboard-pci \
    -drive "format=raw,file=./machine-lts/edk2-aarch64-code.fd,if=pflash,readonly=on" \
    -drive "format=raw,file=./machine-lts/ovmf_vars.fd,if=pflash" \
    -drive "format=qcow2,file=./machine-lts/virtual-disk.qcow2" \
    -cdrom ./machine-lts/ubuntu-lts.iso &

  # echo
  # read "?Username: " Username
  # read "?Password: " Password
  # echo

  # echo "$Username ~ $Password" >./machine-lts/initialized.txt

fi
