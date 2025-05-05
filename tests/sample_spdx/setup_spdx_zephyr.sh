#!/bin/bash

# filepath: c:\Users\kakan\OneDrive - InfoMagnus LLC\IM\Repos\ARM\setup_spdx_zephyr.sh

# Exit on error
set -e

echo "Step 1: Install cmake and Zephyr SDK"
sudo apt update
sudo apt install -y cmake

cd ~
wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.17.0/zephyr-sdk-0.17.0_linux-x86_64.tar.xz
wget -O - https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.17.0/sha256.sum | shasum --check --ignore-missing
tar xvf zephyr-sdk-0.17.0_linux-x86_64.tar.xz
cd zephyr-sdk-0.17.0
./setup.sh

echo "Step 2: Add SDK to Bash Profile"
echo 'export ZEPHYR_SDK_INSTALL_DIR=$HOME/zephyr-sdk-0.17.0' >> ~/.bashrc
source ~/.bashrc

echo "Step 3: Install udev Rules (Optional but Recommended)"
sudo cp ~/zephyr-sdk-0.17.0/sysroots/x86_64-pokysdk-linux/usr/share/openocd/contrib/60-openocd.rules /etc/udev/rules.d
sudo udevadm control --reload

echo "Step 4: Set Up Your Zephyr Project Environment"
# Create a new directory for the project
PROJECT_DIR=~/zephyr_project
mkdir -p $PROJECT_DIR
cd $PROJECT_DIR

# Create and activate a Python virtual environment
python3 -m venv .venv
source .venv/bin/activate

echo "Step 5: Install Dependencies"
pip install west pyelftools
sudo apt install -y ninja-build

echo "Step 6: Initialize the Zephyr Project with west"
west init -m https://github.com/zephyrproject-rtos/zephyr.git
west update

echo "Step 7: Enable SPDX Output in the Sample Project"
PRJ_CONF=zephyr/samples/hello_world/prj.conf
echo "CONFIG_BUILD_OUTPUT_META=y" >> $PRJ_CONF

echo "Step 8: Initialize the SPDX Build Folder"
west spdx --init -d build

echo "Step 9: Build the Project and Generate SPDX Data"
west build -b qemu_x86 ./zephyr/samples/hello_world --pristine
west spdx -d build

echo "Step 10: Verify SPDX Output Files"
find . -type f | grep -i "\.spdx"

echo "SPDX files generated successfully!"