data=("$@")

MASTER_DIR=~/.svir/.machines/ubuntu-lts-arm
WORK_DIR=~/.svir
INAME=${data[1]}

case ${data[0]} in

# Initializing machine
init | initialize)
  case ${data[1]} in
  ubuntu-lts-arm)
    mkdir -p $MASTER_DIR
    curl https://cdimage.ubuntu.com/releases/20.04/release/ubuntu-20.04.2-live-server-arm64.iso -o $MASTER_DIR/ubuntu-lts-arm.iso
    qemu-img create -f qcow2 $MASTER_DIR/virtual-disk.qcow2 10G
    cp $(dirname $(which qemu-img))/../share/qemu/edk2-aarch64-code.fd $MASTER_DIR
    dd if=/dev/zero conv=sync bs=1m count=64 of=$MASTER_DIR/ovmf_vars.fd
    qemu-system-aarch64 \
      -machine virt,accel=hvf,highmem=off \
      -cpu cortex-a72 -smp 4 -m 4G \
      -device virtio-gpu-pci \
      -device virtio-keyboard-pci \
      -drive "format=raw,file=$MASTER_DIR/edk2-aarch64-code.fd,if=pflash,readonly=on" \
      -drive "format=raw,file=$MASTER_DIR/ovmf_vars.fd,if=pflash" \
      -drive "format=qcow2,file=$MASTER_DIR/virtual-disk.qcow2" \
      -cdrom $MASTER_DIR/ubuntu-lts-arm.iso
    rm $MASTER_DIR/ubuntu-lts-arm.iso
    ;;
  esac
  ;;

# Deleting an instance
delete)
  if [ ! -d $WORK_DIR/$INAME ]; then
    echo "No such instance!"
    exit 1
  else
    echo "Removing instance $INAME"
    rm -rf $WORK_DIR/$INAME
  fi
  ;;

# Launching an instance
launch)
  cd $WORK_DIR
  if [ ! $(ls -l | grep -c ^d) -lt 8 ]; then
    echo "Too many instances exists already!"
    exit 1
  else
    INAME=$(base64 </dev/urandom | tr -dc 'A-Z' | head -c6)
    echo "Launching $INAME"
    cp -R $MASTER_DIR $WORK_DIR/$INAME
  fi
  ;;

# Listing all instances
list | ls)
  if [ $(ls -l | grep -c ^d) -lt 1 ]; then
    echo "Create an instance first!"
    exit 1
  else
    ls $WORK_DIR
  fi
  ;;

# Accessing an instance
shell)
  if [ ! -d $WORK_DIR/$INAME ]; then
    echo "No such instance!"
    exit 1
  fi
  qemu-system-aarch64 \
    -machine virt,accel=hvf,highmem=off \
    -cpu cortex-a72 -smp 4 -m 4G \
    -device virtio-gpu-pci \
    -device virtio-keyboard-pci \
    -drive "format=raw,file=$WORK_DIR/$INAME/edk2-aarch64-code.fd,if=pflash,readonly=on" \
    -drive "format=raw,file=$WORK_DIR/$INAME/ovmf_vars.fd,if=pflash" \
    -drive "format=qcow2,file=$WORK_DIR/$INAME/virtual-disk.qcow2" \
    -nic hostfwd=tcp:127.0.0.1:9922-0.0.0.0:22,hostfwd=tcp:127.0.0.1:9980-0.0.0.0:80 2>/dev/null &
  ;;
esac
