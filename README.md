# bcm2711-kernel-bis
Automated build of a tweaked version of the latest 64-bit `bcm2711_defconfig` Linux kernel for the RPi4, updated weekly.

**Caution - this repo is work in progress, and not yet ready for production use!**

## Description

<img src="https://raw.githubusercontent.com/sakaki-/resources/master/raspberrypi/pi4/Raspberry_Pi_4_B.jpg" alt="Raspberry Pi 4 B" width="250px" align="right"/>

This project contains a weekly autobuild of the default branch (currently, `rpi-4.19.y`) of the [official Raspberry Pi Linux source tree](https://github.com/raspberrypi/linux), for the [64-bit Raspberry Pi 4](https://www.raspberrypi.org/products/raspberry-pi-4-model-b/).

As with its sister project [bcm2711-kernel](https://github.com/sakaki-/bcm2711-kernel), the baseline build configuration is the upstream `bcm2711_defconfig`, wherein the first 12 hex digits of the tip commit SHA1 hash plus `-p4` are appended to `CONFIGLOCALVERSION` (with a separating hyphen). However, in *this* project, `-bis` is additionally appended to `CONFIGLOCALVERSION`, and (more importantly) additional tweaks are *also* applied to the kernel source and configuration before building, by running the [`patch_kernel.sh`](https://github.com/sakaki-/bcm2711-kernel-bis/blob/master/patch_kernel.sh) and [`conform_config.sh`](https://github.com/sakaki-/bcm2711-kernel-bis/blob/master/conform_config.sh) scripts, respectively.

> If you have changes you'd like to apply to the kernel config used by this project, please submit a PR targeting the [`patch_kernel.sh`](https://github.com/sakaki-/bcm2711-kernel-bis/blob/master/patch_kernel.sh) or [`conform_config.sh`](https://github.com/sakaki-/bcm2711-kernel-bis/blob/master/conform_config.sh) script, as appropriate. Changes should target the *end* of the script. Only edits which use the bundled convenience functions `apply_pr` (for `patch_kernel.sh`) and `set_kernel_config` and (rarely) `unset_kernel_config` (for `conform_config.sh`) will be considered for merging. Modularization is prefered wherever possible. Please include a short comment describing the changes, ideally including a link or bug ID.

A new build tarball is automatically created and uploaded as a release asset each week (unless the tip of the default branch is unchanged from the prior week, or an error occurs during the build process). The versions of the builds in this project will always mirror those of [bcm2711-kernel](https://github.com/sakaki-/bcm2711-kernel).

> The default branch is used, as that is generally given most attention by RPF upstream.

As an (historical) example, on 24 July 2019, the default branch was `rpi-4.19.y` and the latest commit was `689fc28a5af07cedb88760b2f35b1eb6f6a7e112` (the short form of which is `689fc28a5af0`). The created release was [4.19.59.20190724](https://github.com/sakaki-/bcm2711-kernel-bis/releases/tag/4.19.59.20190724), within which the kernel tarball was `bcm2711-kernel-bis-4.19.59.20190724.tar.xz`, and the corresponding kernel release name was `4.19.59-v8-689fc28a5af0-p4-bis+`.

Each kernel release tarball currently provides the following files:
* `/boot/kernel8-p4.img` (this is the bootable 64-bit kernel);
* `/boot/COPYING.linux` (the kernel's license file);
* `/boot/config-p4` (the configuration used to build the kernel);
* `/boot/System-p4.map` (the kernel's symbol table);
* `/boot/bcm2711-rpi-4-b.dtb` (the device tree blob; currently only one);
* `/boot/armstub8-gic.bin` (stubs required - on older boot firmware only - for the GIC);
* `/boot/overlays/...` (the device tree blob overlays);
* `/lib/modules/<kernel release name>/...` (the module set for the kernel).

The current kernel tarball may be downloaded from the link below (or via `wget`, or via the corresponding `bcm2711-kernel-bis-bin` ebuild, per the [instructions following](#installation)):

Variant | Version | Most Recent Image
:--- | ---: | ---:
Kernel, dtbs, modules and GIC stub | 4.19.66.20190820 | [bcm2711-kernel-bis-4.19.66.20190820.tar.xz](https://github.com/sakaki-/bcm2711-kernel-bis/releases/download/4.19.66.20190820/bcm2711-kernel-bis-4.19.66.20190820.tar.xz)

The corresponding kernel configuration (derived via `make bcm2711_defconfig && conform_config.sh && make olddefconfig`) may be viewed [here](https://github.com/sakaki-/bcm2711-kernel-bis/blob/master/config). The 'baseline' `bcm2711_defconfig` may be viewed [here](https://github.com/sakaki-/bcm2711-kernel-bis/blob/master/bcm2711_config), the `conform_config.sh` script may be viewed [here](https://github.com/sakaki-/bcm2711-kernel-bis/blob/master/conform_config.sh), and a diff between the 'tweaked' and 'baseline' configurations may be viewed [here](https://github.com/sakaki-/bcm2711-kernel-bis/blob/master/vs_bcm2711_config.diff).

> A list of all releases may be seen [here](https://github.com/sakaki-/bcm2711-kernel-bis/releases).

## <a name="installation"></a>Installation

You can simply untar a kernel release tarball from this project into an existing (32 or 64-bit) OS image to deploy it.

### <a name="add_to_raspbian"></a>Example 1: Converting a 32-bit Raspbian Image

For example, to allow the current 32-bit userland Raspbian (with desktop) image to be booted under a 64-bit kernel on a Pi4, proceed as follows.

> For simplicity, I will assume you are working on a Linux PC, as root, here.

Begin by downloading and writing the Raspbian Buster image onto a _unused_ microSD card, and mounting it. Assuming the card appears as `/dev/mmcblk0` on your PC, and your OS image has two partitions (bootfs on the first, rootfs on the second, as Raspbian does), issue:

```console
linuxpc ~ # wget -cO- https://downloads.raspberrypi.org/raspbian_latest | bsdtar -xOf- > /dev/mmcblk0
linuxpc ~ # sync && partprobe /dev/mmcblk0
linuxpc ~ # mkdir -pv /mnt/piroot
linuxpc ~ # mount -v /dev/mmcblk0p2 /mnt/piroot
linuxpc ~ # mount -v /dev/mmcblk0p1 /mnt/piroot/boot
```

> NB: you **must** take care to substitute the correct path for your microSD card (which may appear as something completely different from `/dev/mmcblk0`, depending on your system) in these instructions, as the contents of the target drive will be irrevocably overwritten by the above operation.

Next, fetch the the current kernel tarball, and untar it into the mounted image. Issue:

```console
linuxpc ~ # wget -cO- https://github.com/sakaki-/bcm2711-kernel-bis/releases/download/4.19.66.20190820/bcm2711-kernel-bis-4.19.66.20190820.tar.xz | tar -xJf- -C /mnt/piroot/
```

Then, edit the image's `/boot/config.txt`:

```console
linuxpc ~ # nano -w /mnt/piroot/boot/config.txt
```

Modify the [pi4] section of this file (it appears near the end of the file), so it reads as follows:
```ini
[pi4]
# Enable DRM VC4 V3D driver on top of the dispmanx display stack
dtoverlay=vc4-fkms-v3d
max_framebuffers=2
arm_64bit=1
# differentiate from Pi3 64-bit kernels
kernel=kernel8-p4.img
```

> Note that the previous requirement to set `armstub8-gic.bin` and `enable_gic=1` in the above file, is obviated by the use of the *current* boot firmware (`start4*.elf` and `fixup4*.dat`) on the RPi4. With modern kernels, the `total_mem` clamp can safely be omitted too (as above).

Leave the rest of the file as-is. Save, and exit `nano`. Then unmount the image:

```console
linuxpc ~ # sync
linuxpc ~ # umount -v /mnt/piroot/{boot,}
```

If you now remove the microSD card, insert it into a RPi4, and power on, you should find it starts up under the 64-bit kernel!

### <a name="update_kernel"></a>Example 2: Updating an Existing, Booted Image

If you would like to update a RPi4 image you are currently *booted* into, you can update to the latest release by issuing:

```console
pi4 ~ # wget -cO- https://github.com/sakaki-/bcm2711-kernel-bis/releases/download/4.19.66.20190820/bcm2711-kernel-bis-4.19.66.20190820.tar.xz | tar -xJf- -C /
pi4 ~ # sync
```

Once this completes, modify `/boot/config.txt` (if you have not already done so) as shown [above](#add_to_raspbian). Then simply reboot, and you should be using your new kernel!

> Users of my [rpi3 overlay](https://github.com/sakaki-/rpi3-overlay) (it is pre-installed on the [gentoo-on-rpi3-64bit](https://github.com/sakaki-/gentoo-on-rpi3-64bit) image, for example), can simply `emerge` the `bcm2711-kernel-bis-bin` package to deploy (a new ebuild is automatically created to mirror each release here).

> NB: these prebuilt kernels and ebuilds are provided as a convenience only. Use at your own risk! **Given that the releases in this project are created automatically, and particularly since they include user-submitted tweaks to the 'official' `bcm2711_defconfig`, there is no guarantee that any given kernel will boot correctly.** A 64-bit kernel is necessary, but not sufficient, to boot the RPi4 in 64-bit mode; you also need the supporting firmware, configuration files, and userland software.
