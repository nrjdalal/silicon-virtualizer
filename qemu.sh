# qemu-img create -f qcow2 ubuntu.qcow2 8G

# cp $(dirname $(which qemu-img))/../share/qemu/edk2-aarch64-code.fd .

# qemu-system-aarch64 -machine virt,highmem=off \
#   -accel hvf -cpu cortex-a72 -smp 2 -m 2G \
#   -device virtio-gpu-pci \
#   -device virtio-keyboard-pci \
#   -device virtio-mouse-pci \
#   -device virtio-net-pci,netdev=net \
#   -netdev user,id=net,ipv6=off \
#   -drive "if=pflash,format=raw,file=./edk2-aarch64-code.fd,readonly=on" \
#   -drive "if=virtio,file=./ubuntu.qcow2" \
#   -cdrom ubuntu-arm64.iso

# # -drive "if=pflash,format=raw,file=./edk2-aarch64-code.fd,readonly=on" \
# # -drive "if=pflash,format=raw,file=./edk2-arm-vars.fd,discard=on" \

# qemu-img create -f qcow2 ubuntu.qcow2 10G
# dd if=/dev/zero conv=sync bs=1m count=64 of=ovmf_vars.fd
# cp $(dirname $(which qemu-img))/../share/qemu/edk2-aarch64-code.fd .

qemu-system-aarch64 \
  -machine virt,highmem=off \
  -cpu cortex-a72 \
  -accel hvf \
  -smp 2 \
  -m 2G \
  -device virtio-gpu-pci \
  -device virtio-keyboard-pci \
  -drive "if=pflash,format=raw,file=./edk2-aarch64-code.fd,readonly=on" \
  -drive "if=pflash,format=raw,file=ovmf_vars.fd" \
  -drive "if=virtio,format=qcow2,file=./ubuntu.qcow2"
# -cdrom ubuntu-arm64.iso

# -device virtio-mouse-pci \
# -device virtio-net-pci,netdev=net \
# -netdev user,id=net,ipv6=off \
# -nic user,id=net,model=virtio,hostfwd=tcp:127.0.0.1:9922-0.0.0.0:22 \

# qemu-system-aarch64 \
#   -device ramfb \
#   -device usb-ehci \
#   -device usb-kbd \
#   -device usb-mouse -usb \
#   -device virtio-blk-device,drive=hd0,serial="dummyserial" \
#   -device virtio-net-device,netdev=net0 \
#   -drive file=/usr/local/share/qemu/edk2-aarch64-code.fd,if=pflash,format=raw,readonly=on \
#   -drive file=ovmf_vars.fd,format=raw,if=pflash \
#   -drive if=none,file=disk.qcow2,format=qcow2,id=hd0 \
#   -m 2048 \
#   -M virt,highmem=off \
#   -monitor stdio \
#   -netdev user,id=net0 \
#   -serial telnet::4444,server,nowait \
#   -vga none
