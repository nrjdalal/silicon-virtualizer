# Clone QEMU
git clone https://github.com/qemu/qemu

# Change directory to qemu repository
cd qemu

# Checkout to commit dated May 26, 2021
git checkout 75eebe0b1f15464d19a39c4186bfabf328ab601a

# Apply patch series v8 by Alexander Graf
curl https://patchwork.kernel.org/series/485309/mbox/ | git am

# Building qemu installer
mkdir build
cd build
../configure --target-list=aarch64-softmmu
make -j8

# Install qemu
sudo make install
