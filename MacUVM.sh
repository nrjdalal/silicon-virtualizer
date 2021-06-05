# qemu-img create -f qcow2 disk.qcow2 8G
# cp $(dirname $(which qemu-img))/../share/qemu/edk2-aarch64-code.fd .
# dd if=/dev/zero conv=sync bs=1m count=64 of=ovmf_vars.fd

qemu-system-aarch64 \
  -machine virt,accel=hvf,highmem=off \
  -cpu cortex-a72 -smp 4 -m 4G \
  -device virtio-gpu-pci \
  -device virtio-keyboard-pci \
  -drive "format=raw,file=edk2-aarch64-code.fd,if=pflash,readonly=on" \
  -drive "format=raw,file=ovmf_vars.fd,if=pflash" \
  -drive "format=qcow2,file=disk.qcow2" \
  -nic hostfwd=tcp:127.0.0.1:9922-0.0.0.0:22,hostfwd=tcp:127.0.0.1:9980-0.0.0.0:80
# -cdrom ubuntu-arm64.iso
