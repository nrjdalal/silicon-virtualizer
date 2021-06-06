# Install Xcode command line tools
xcode-select --install 2>/dev/null

# Install Homebrew arm64
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$(logname)/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install necessary packages for building
brew install libffi gettext glib pkg-config autoconf automake pixman ninja

# Clone qemu
git clone https://github.com/qemu/qemu

# Change directory to qemu repository
cd qemu

# Checkout to commit dated June 03, 2021 v6.0.0
git checkout 3c93dfa42c394fdd55684f2fbf24cf2f39b97d47

# Apply patch series v8 by Alexander Graf
curl https://patchwork.kernel.org/series/485309/mbox/ | git am

# Building qemu installer
mkdir build && cd build
../configure --target-list=aarch64-softmmu
make -j8

# Install qemu
sudo make install
