# Creating SPDX Files with `west` and `zephyr` Sample HelloWorld Project

> ⚠️ The process is bug-prone on Windows but should work on a Linux.

---

## Step 1: Install cmake and Zephyr SDK

```bash
sudo apt update
sudo apt install cmake -y

cd ~
wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.17.0/zephyr-sdk-0.17.0_linux-x86_64.tar.xz
wget -O - https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.17.0/sha256.sum | shasum --check --ignore-missing
tar xvf zephyr-sdk-0.17.0_linux-x86_64.tar.xz
cd zephyr-sdk-0.17.0
./setup.sh
```

## Step 2: Add SDK to Bash Profile
```
echo 'export ZEPHYR_SDK_INSTALL_DIR=$HOME/zephyr-sdk-0.17.0' >> ~/.bashrc
source ~/.bashrc
```

## Step 3: Install udev Rules (Optional but Recommended)
```
sudo cp ~/zephyr-sdk-0.17.0/sysroots/x86_64-pokysdk-linux/usr/share/openocd/contrib/60-openocd.rules /etc/udev/rules.d
sudo udevadm control --reload
```

## Step 4: Set Up Your Zephyr Project Environment
1. Create a new directory under your home directory. The directory name cannot contain spaces.
2. `cd` into it.
3. Create and activate a Python virtual environment:
```
python -m venv .venv
source .venv/bin/activate
```
## Step 5: Install Dependencies
```
pip install west pyelftools
sudo apt install ninja-build
```
## Step 6: Initialize the Zephyr Project with west
```
west init -m https://github.com/zephyrproject-rtos/zephyr.git
west update
```

## Step 7: Enable SPDX Output in the Sample Project
Open `./zephyr/samples/hello_world/prj.conf` and add the following line:
```
CONFIG_BUILD_OUTPUT_META=y
```

## Step 8: Initialize the SPDX Build Folder
```
west spdx --init -d build
```

## Step 9: Build the Project and Generate SPDX Data
```
west build -b qemu_x86 ./zephyr/samples/hello_world --pristine
west spdx -d build
```
## Step 10: Verify SPDX Output Files
Run `find . -type f | grep -i "\.spdx"`. You should see:
```
./build/spdx/modules-deps.spdx
./build/spdx/app.spdx
./build/spdx/build.spdx
./build/spdx/zephyr.spdx
```

