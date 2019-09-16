#!/bin/bash
#
# Simple script to tweak an existing baseline kernel .config file.
#
# Copyright (c) 2018-19 sakaki <sakaki@deciban.com>
# License: GPL v2.0
# NO WARRANTY
#

set -e
set -u
shopt -s nullglob

# Utility functions

set_kernel_config() {
    # flag as $1, value to set as $2, config must exist at "./.config"
    local TGT="CONFIG_${1#CONFIG_}"
    local REP="${2//\//\\/}"
    if grep -q "^${TGT}[^_]" .config; then
        sed -i "s/^\(${TGT}=.*\|# ${TGT} is not set\)/${TGT}=${REP}/" .config
    else
        echo "${TGT}=${2}" >> .config
    fi
}

unset_kernel_config() {
    # unsets flag with the value of $1, config must exist at "./.config"
    local TGT="CONFIG_${1#CONFIG_}"
    sed -i "s/^${TGT}=.*/# ${TGT} is not set/" .config
}

# Custom config settings follow

# Submit PRs with edits targeting the _bottom_ of this file
# Please set modules where possible, rather than building in, and
# provide a short rationale comment for the changes made

# enable basic KVM support; see e.g.
# https://www.raspberrypi.org/forums/viewtopic.php?f=63&t=210546&start=25#p1300453
set_kernel_config CONFIG_VIRTUALIZATION y
set_kernel_config CONFIG_KVM y
set_kernel_config CONFIG_VHOST_NET m
set_kernel_config CONFIG_VHOST_CROSS_ENDIAN_LEGACY y

# enable ZSWAP support for better performance during large builds etc.
# requires activation via kernel parameter or sysfs
# see e.g. https://askubuntu.com/a/472227 for a summary of ZSWAP (vs ZRAM etc.)
# and e.g. https://wiki.archlinux.org/index.php/zswap for parameters etc.
set_kernel_config CONFIG_ZPOOL y
set_kernel_config CONFIG_ZSWAP y
set_kernel_config CONFIG_ZBUD y
set_kernel_config CONFIG_Z3FOLD y
set_kernel_config CONFIG_ZSMALLOC y
set_kernel_config CONFIG_PGTABLE_MAPPING y

# https://groups.google.com/forum/#!topic/linux.gentoo.user/_2aSc_ztGpA
# https://github.com/torvalds/linux/blob/master/init/Kconfig#L848
# Enables BPF syscall for systemd-journald firewalling
set_kernel_config CONFIG_BPF_SYSCALL y
set_kernel_config CONFIG_CGROUP_BPF y

#See https://github.com/raspberrypi/linux/issues/2177#issuecomment-354647406
# Netfilter kernel support
# xtables
set_kernel_config CONFIG_NETFILTER_XTABLES m
# Netfilter nf_tables support
set_kernel_config CONFIG_NF_TABLES m
set_kernel_config CONFIG_NETFILTER_XTABLES m
set_kernel_config CONFIG_NF_TABLES_BRIDGE m
set_kernel_config CONFIG_NF_NAT_SIP m
set_kernel_config CONFIG_NF_NAT_TFTP m
set_kernel_config CONFIG_NF_NAT_REDIRECT m
set_kernel_config CONFIG_NF_TABLES_INET m
set_kernel_config CONFIG_NF_TABLES_NETDEV m
set_kernel_config CONFIG_NF_TABLES_ARP m
set_kernel_config CONFIG_NF_DUP_IPV4 m
set_kernel_config CONFIG_NF_LOG_IPV4 m
set_kernel_config CONFIG_NF_REJECT_IPV4 m
set_kernel_config CONFIG_NF_NAT_IPV4 m
set_kernel_config CONFIG_NF_DUP_NETDEV m
set_kernel_config CONFIG_NF_DEFRAG_IPV4 m
set_kernel_config CONFIG_NF_CONNTRACK_IPV4 m
set_kernel_config CONFIG_NF_TABLES_IPV4 m
set_kernel_config CONFIG_NF_NAT_MASQUERADE_IPV4 m
set_kernel_config CONFIG_NF_NAT_SNMP_BASIC m
set_kernel_config CONFIG_NF_NAT_PROTO_GRE m
set_kernel_config CONFIG_NF_NAT_PPTP m
set_kernel_config CONFIG_NF_DEFRAG_IPV6 m
set_kernel_config CONFIG_NF_CONNTRACK_IPV6 m
set_kernel_config CONFIG_NF_TABLES_IPV6 m
set_kernel_config CONFIG_NF_DUP_IPV6 m
set_kernel_config CONFIG_NF_REJECT_IPV6 m
set_kernel_config CONFIG_NF_LOG_IPV6 m
set_kernel_config CONFIG_NF_NAT_IPV6 m
set_kernel_config CONFIG_NF_NAT_MASQUERADE_IPV6 m
set_kernel_config CONFIG_NFT_EXTHDR m
set_kernel_config CONFIG_NFT_META m
set_kernel_config CONFIG_NFT_NUMGEN m
set_kernel_config CONFIG_NFT_CT m
set_kernel_config CONFIG_NFT_SET_RBTREE m
set_kernel_config CONFIG_NFT_SET_HASH m
set_kernel_config CONFIG_NFT_COUNTER m
set_kernel_config CONFIG_NFT_LOG m
set_kernel_config CONFIG_NFT_LIMIT m
set_kernel_config CONFIG_NFT_MASQ m
set_kernel_config CONFIG_NFT_REDIR m
set_kernel_config CONFIG_NFT_NAT m
set_kernel_config CONFIG_NFT_QUEUE m
set_kernel_config CONFIG_NFT_QUOTA m
set_kernel_config CONFIG_NFT_REJECT m
set_kernel_config CONFIG_NFT_REJECT_INET m
set_kernel_config CONFIG_NFT_COMPAT m
set_kernel_config CONFIG_NFT_HASH m
set_kernel_config CONFIG_NFT_DUP_NETDEV m
set_kernel_config CONFIG_NFT_FWD_NETDEV m
set_kernel_config CONFIG_NFT_CHAIN_ROUTE_IPV4 m
set_kernel_config CONFIG_NFT_REJECT_IPV4 m
set_kernel_config CONFIG_NFT_DUP_IPV4 m
set_kernel_config CONFIG_NFT_CHAIN_NAT_IPV4 m
set_kernel_config CONFIG_NFT_MASQ_IPV4 m
set_kernel_config CONFIG_NFT_REDIR_IPV4 m
set_kernel_config CONFIG_NFT_CHAIN_ROUTE_IPV6 m
set_kernel_config CONFIG_NFT_REJECT_IPV6 m
set_kernel_config CONFIG_NFT_DUP_IPV6 m
set_kernel_config CONFIG_NFT_CHAIN_NAT_IPV6 m
set_kernel_config CONFIG_NFT_MASQ_IPV6 m
set_kernel_config CONFIG_NFT_REDIR_IPV6 m
set_kernel_config CONFIG_NFT_BRIDGE_META m
set_kernel_config CONFIG_NFT_BRIDGE_REJECT m
set_kernel_config CONFIG_IP_SET_BITMAP_IPMAC m
set_kernel_config CONFIG_IP_SET_BITMAP_PORT m
set_kernel_config CONFIG_IP_SET_HASH_IP m
set_kernel_config CONFIG_IP_SET_HASH_IPMARK m
set_kernel_config CONFIG_IP_SET_HASH_IPPORT m
set_kernel_config CONFIG_IP_SET_HASH_IPPORTIP m
set_kernel_config CONFIG_IP_SET_HASH_IPPORTNET m
set_kernel_config CONFIG_IP_SET_HASH_MAC m
set_kernel_config CONFIG_IP_SET_HASH_NETPORTNET m
set_kernel_config CONFIG_IP_SET_HASH_NET m
set_kernel_config CONFIG_IP_SET_HASH_NETNET m
set_kernel_config CONFIG_IP_SET_HASH_NETPORT m
set_kernel_config CONFIG_IP_SET_HASH_NETIFACE m
set_kernel_config CONFIG_IP_SET_LIST_SET m
set_kernel_config CONFIG_IP6_NF_IPTABLES m
set_kernel_config CONFIG_IP6_NF_MATCH_AH m
set_kernel_config CONFIG_IP6_NF_MATCH_EUI64 m
set_kernel_config CONFIG_IP6_NF_NAT m
set_kernel_config CONFIG_IP6_NF_TARGET_MASQUERADE m
set_kernel_config CONFIG_IP6_NF_TARGET_NPT m
set_kernel_config CONFIG_NF_LOG_BRIDGE m
set_kernel_config CONFIG_BRIDGE_NF_EBTABLES m
set_kernel_config CONFIG_BRIDGE_EBT_BROUTE m
set_kernel_config CONFIG_BRIDGE_EBT_T_FILTER m 

# Mask this temporarily during switch to rpi-4.19.y
# Fix SD_DRIVER upstream and downstream problem in 64bit defconfig
# use correct driver MMC_BCM2835_MMC instead of MMC_BCM2835_SDHOST - see https://www.raspberrypi.org/forums/viewtopic.php?t=210225
#set_kernel_config CONFIG_MMC_BCM2835 n
#set_kernel_config CONFIG_MMC_SDHCI_IPROC n
#set_kernel_config CONFIG_USB_DWC2 n
#sed -i "s|depends on MMC_BCM2835_MMC && MMC_BCM2835_DMA|depends on MMC_BCM2835_MMC|" ./drivers/mmc/host/Kconfig

# Enable VLAN support again (its in armv7 configs)
set_kernel_config CONFIG_IPVLAN m

# Enable SoC camera support
# See https://www.raspberrypi.org/forums/viewtopic.php?p=1425257#p1425257
set_kernel_config CONFIG_VIDEO_V4L2_SUBDEV_API y
set_kernel_config CONFIG_VIDEO_BCM2835_UNICAM m

# Enable RPI POE HAT fan
set_kernel_config CONFIG_SENSORS_RPI_POE_FAN m

# Enable per-interface network priority control
# (for systemd-nspawn)
set_kernel_config CONFIG_CGROUP_NET_PRIO y

# Compile in BTRFS
set_kernel_config CONFIG_BTRFS_FS y
set_kernel_config CONFIG_BTRFS_FS_POSIX_ACL y
set_kernel_config CONFIG_BTRFS_FS_REF_VERIFY y

# Following are set in current 32-bit LPAE kernel
set_kernel_config CONFIG_CGROUP_PIDS y
set_kernel_config CONFIG_NET_IPVTI m
set_kernel_config CONFIG_NF_TABLES_SET m
set_kernel_config CONFIG_NF_TABLES_INET y
set_kernel_config CONFIG_NF_TABLES_NETDEV y
set_kernel_config CONFIG_NF_FLOW_TABLE m
set_kernel_config CONFIG_NFT_FLOW_OFFLOAD m
set_kernel_config CONFIG_NFT_CONNLIMIT m
set_kernel_config CONFIG_NFT_TUNNEL m
set_kernel_config CONFIG_NFT_OBJREF m
set_kernel_config CONFIG_NFT_FIB_IPV4 m
set_kernel_config CONFIG_NFT_FIB_IPV6 m
set_kernel_config CONFIG_NFT_FIB_INET m
set_kernel_config CONFIG_NFT_SOCKET m
set_kernel_config CONFIG_NFT_OSF m
set_kernel_config CONFIG_NFT_TPROXY m
set_kernel_config CONFIG_NF_DUP_NETDEV m
set_kernel_config CONFIG_NFT_DUP_NETDEV m
set_kernel_config CONFIG_NFT_FWD_NETDEV m
set_kernel_config CONFIG_NFT_FIB_NETDEV m
set_kernel_config CONFIG_NF_FLOW_TABLE_INET m
set_kernel_config CONFIG_NF_FLOW_TABLE m
set_kernel_config CONFIG_NETFILTER_XT_MATCH_SOCKET m
set_kernel_config CONFIG_NFT_CHAIN_ROUTE_IPV6 m
set_kernel_config CONFIG_NFT_CHAIN_NAT_IPV6 m
set_kernel_config CONFIG_NFT_MASQ_IPV6 m
set_kernel_config CONFIG_NFT_REDIR_IPV6 m
set_kernel_config CONFIG_NFT_REJECT_IPV6 m
set_kernel_config CONFIG_NFT_DUP_IPV6 m
set_kernel_config CONFIG_NFT_FIB_IPV6 m
set_kernel_config CONFIG_NF_FLOW_TABLE_IPV6 m
set_kernel_config CONFIG_NF_TABLES_BRIDGE m
set_kernel_config CONFIG_NFT_BRIDGE_REJECT m
set_kernel_config CONFIG_NF_LOG_BRIDGE m
set_kernel_config CONFIG_MT76_CORE m
set_kernel_config CONFIG_MT76_LEDS m
set_kernel_config CONFIG_MT76_USB m
set_kernel_config CONFIG_MT76x2_COMMON m
set_kernel_config CONFIG_MT76x0U m
set_kernel_config CONFIG_MT76x2U m
set_kernel_config CONFIG_TOUCHSCREEN_ILI210X m
set_kernel_config CONFIG_BCM_VC_SM m
set_kernel_config CONFIG_BCM2835_SMI_DEV m
set_kernel_config CONFIG_RPIVID_MEM m
set_kernel_config CONFIG_HW_RANDOM_BCM2835 y
set_kernel_config CONFIG_TCG_TPM m
set_kernel_config CONFIG_HW_RANDOM_TPM y
set_kernel_config CONFIG_TCG_TIS m
set_kernel_config CONFIG_TCG_TIS_SPI m
set_kernel_config CONFIG_I2C_MUX m
set_kernel_config CONFIG_I2C_MUX_GPMUX m
set_kernel_config CONFIG_I2C_MUX_PCA954x m
set_kernel_config CONFIG_SPI_GPIO m
set_kernel_config CONFIG_BATTERY_MAX17040 m
set_kernel_config CONFIG_SENSORS_GPIO_FAN m
set_kernel_config CONFIG_SENSORS_RASPBERRYPI_HWMON m
set_kernel_config CONFIG_BCM2835_THERMAL y
set_kernel_config CONFIG_RC_CORE y
set_kernel_config CONFIG_RC_MAP y
set_kernel_config CONFIG_LIRC y
set_kernel_config CONFIG_RC_DECODERS y
set_kernel_config CONFIG_IR_NEC_DECODER m
set_kernel_config CONFIG_IR_RC5_DECODER m
set_kernel_config CONFIG_IR_RC6_DECODER m
set_kernel_config CONFIG_IR_JVC_DECODER m
set_kernel_config CONFIG_IR_SONY_DECODER m
set_kernel_config CONFIG_IR_SANYO_DECODER m
set_kernel_config CONFIG_IR_SHARP_DECODER m
set_kernel_config CONFIG_IR_MCE_KBD_DECODER m
set_kernel_config CONFIG_IR_XMP_DECODER m
set_kernel_config CONFIG_IR_IMON_DECODER m
set_kernel_config CONFIG_RC_DEVICES y
set_kernel_config CONFIG_RC_ATI_REMOTE m
set_kernel_config CONFIG_IR_IMON m
set_kernel_config CONFIG_IR_MCEUSB m
set_kernel_config CONFIG_IR_REDRAT3 m
set_kernel_config CONFIG_IR_STREAMZAP m
set_kernel_config CONFIG_IR_IGUANA m
set_kernel_config CONFIG_IR_TTUSBIR m
set_kernel_config CONFIG_RC_LOOPBACK m
set_kernel_config CONFIG_IR_GPIO_CIR m
set_kernel_config CONFIG_IR_GPIO_TX m
set_kernel_config CONFIG_IR_PWM_TX m
set_kernel_config CONFIG_VIDEO_V4L2_SUBDEV_API y
set_kernel_config CONFIG_VIDEO_AU0828_RC y
set_kernel_config CONFIG_VIDEO_CX231XX m
set_kernel_config CONFIG_VIDEO_CX231XX_RC y
set_kernel_config CONFIG_VIDEO_CX231XX_ALSA m
set_kernel_config CONFIG_VIDEO_CX231XX_DVB m
set_kernel_config CONFIG_VIDEO_TM6000 m
set_kernel_config CONFIG_VIDEO_TM6000_ALSA m
set_kernel_config CONFIG_VIDEO_TM6000_DVB m
set_kernel_config CONFIG_DVB_USB m
set_kernel_config CONFIG_DVB_USB_DIB3000MC m
set_kernel_config CONFIG_DVB_USB_A800 m
set_kernel_config CONFIG_DVB_USB_DIBUSB_MB m
set_kernel_config CONFIG_DVB_USB_DIBUSB_MB_FAULTY y
set_kernel_config CONFIG_DVB_USB_DIBUSB_MC m
set_kernel_config CONFIG_DVB_USB_DIB0700 m
set_kernel_config CONFIG_DVB_USB_UMT_010 m
set_kernel_config CONFIG_DVB_USB_CXUSB m
set_kernel_config CONFIG_DVB_USB_M920X m
set_kernel_config CONFIG_DVB_USB_DIGITV m
set_kernel_config CONFIG_DVB_USB_VP7045 m
set_kernel_config CONFIG_DVB_USB_VP702X m
set_kernel_config CONFIG_DVB_USB_GP8PSK m
set_kernel_config CONFIG_DVB_USB_NOVA_T_USB2 m
set_kernel_config CONFIG_DVB_USB_TTUSB2 m
set_kernel_config CONFIG_DVB_USB_DTT200U m
set_kernel_config CONFIG_DVB_USB_OPERA1 m
set_kernel_config CONFIG_DVB_USB_AF9005 m
set_kernel_config CONFIG_DVB_USB_AF9005_REMOTE m
set_kernel_config CONFIG_DVB_USB_PCTV452E m
set_kernel_config CONFIG_DVB_USB_DW2102 m
set_kernel_config CONFIG_DVB_USB_CINERGY_T2 m
set_kernel_config CONFIG_DVB_USB_DTV5100 m
set_kernel_config CONFIG_DVB_USB_AZ6027 m
set_kernel_config CONFIG_DVB_USB_TECHNISAT_USB2 m
set_kernel_config CONFIG_DVB_USB_AF9015 m
set_kernel_config CONFIG_DVB_USB_LME2510 m
set_kernel_config CONFIG_DVB_USB_RTL28XXU m
set_kernel_config CONFIG_VIDEO_EM28XX_RC m
set_kernel_config CONFIG_SMS_SIANO_RC m
set_kernel_config CONFIG_VIDEO_IR_I2C m
set_kernel_config CONFIG_VIDEO_ADV7180 m
set_kernel_config CONFIG_VIDEO_TC358743 m
set_kernel_config CONFIG_VIDEO_OV5647 m
set_kernel_config CONFIG_DVB_M88DS3103 m
set_kernel_config CONFIG_DVB_AF9013 m
set_kernel_config CONFIG_DVB_RTL2830 m
set_kernel_config CONFIG_DVB_RTL2832 m
set_kernel_config CONFIG_DVB_SI2168 m
set_kernel_config CONFIG_DVB_GP8PSK_FE m
set_kernel_config CONFIG_DVB_USB m
set_kernel_config CONFIG_DVB_LGDT3306A m
set_kernel_config CONFIG_FB_SIMPLE y
set_kernel_config CONFIG_SND_BCM2708_SOC_IQAUDIO_CODEC m
set_kernel_config CONFIG_SND_BCM2708_SOC_I_SABRE_Q2M m
set_kernel_config CONFIG_SND_AUDIOSENSE_PI m
set_kernel_config CONFIG_SND_SOC_AD193X m
set_kernel_config CONFIG_SND_SOC_AD193X_SPI m
set_kernel_config CONFIG_SND_SOC_AD193X_I2C m
set_kernel_config CONFIG_SND_SOC_CS4265 m
set_kernel_config CONFIG_SND_SOC_DA7213 m
set_kernel_config CONFIG_SND_SOC_ICS43432 m
set_kernel_config CONFIG_SND_SOC_TLV320AIC32X4 m
set_kernel_config CONFIG_SND_SOC_TLV320AIC32X4_I2C m
set_kernel_config CONFIG_SND_SOC_I_SABRE_CODEC m
set_kernel_config CONFIG_HID_BIGBEN_FF m
#set_kernel_config CONFIG_USB_XHCI_PLATFORM y
set_kernel_config CONFIG_USB_TMC m
set_kernel_config CONFIG_USB_UAS y
set_kernel_config CONFIG_USBIP_VUDC m
set_kernel_config CONFIG_USB_CONFIGFS m
set_kernel_config CONFIG_USB_CONFIGFS_SERIAL y
set_kernel_config CONFIG_USB_CONFIGFS_ACM y
set_kernel_config CONFIG_USB_CONFIGFS_OBEX y
set_kernel_config CONFIG_USB_CONFIGFS_NCM y
set_kernel_config CONFIG_USB_CONFIGFS_ECM y
set_kernel_config CONFIG_USB_CONFIGFS_ECM_SUBSET y
set_kernel_config CONFIG_USB_CONFIGFS_RNDIS y
set_kernel_config CONFIG_USB_CONFIGFS_EEM y
set_kernel_config CONFIG_USB_CONFIGFS_MASS_STORAGE y
set_kernel_config CONFIG_USB_CONFIGFS_F_LB_SS y
set_kernel_config CONFIG_USB_CONFIGFS_F_FS y
set_kernel_config CONFIG_USB_CONFIGFS_F_UAC1 y
set_kernel_config CONFIG_USB_CONFIGFS_F_UAC2 y
set_kernel_config CONFIG_USB_CONFIGFS_F_MIDI y
set_kernel_config CONFIG_USB_CONFIGFS_F_HID y
set_kernel_config CONFIG_USB_CONFIGFS_F_UVC y
set_kernel_config CONFIG_USB_CONFIGFS_F_PRINTER y
set_kernel_config CONFIG_LEDS_PCA963X m
set_kernel_config CONFIG_LEDS_IS31FL32XX m
set_kernel_config CONFIG_LEDS_TRIGGER_NETDEV m
set_kernel_config CONFIG_RTC_DRV_RV3028 m
set_kernel_config CONFIG_AUXDISPLAY y
set_kernel_config CONFIG_HD44780 m
set_kernel_config CONFIG_FB_TFT_SH1106 m
set_kernel_config CONFIG_VIDEO_CODEC_BCM2835 m
set_kernel_config CONFIG_BCM2835_POWER y
set_kernel_config CONFIG_INV_MPU6050_IIO m
set_kernel_config CONFIG_INV_MPU6050_I2C m
set_kernel_config CONFIG_SECURITYFS y

# Safer to build this in
set_kernel_config CONFIG_BINFMT_MISC y

# pulseaudio wants a buffer of at least this size
set_kernel_config CONFIG_SND_HDA_PREALLOC_SIZE 2048

# PR#3063: enable 3D acceleration with 64-bit kernel on RPi4
# set the appropriate kernel configs unlocked by this PR
set_kernel_config CONFIG_ARCH_BCM y
set_kernel_config CONFIG_ARCH_BCM2835 y
set_kernel_config CONFIG_DRM_V3D m
set_kernel_config CONFIG_DRM_VC4 m
set_kernel_config CONFIG_DRM_VC4_HDMI_CEC y

# PR#3144: add arm64 pcie bounce buffers; enables 4GiB on RPi4
# required by PR#3144; should already be applied, but just to be safe
set_kernel_config CONFIG_PCIE_BRCMSTB y
set_kernel_config CONFIG_BCM2835_MMC y

# Snap needs squashfs. The ubuntu eoan-preinstalled-server image at 
# http://cdimage.ubuntu.com/ubuntu-server/daily-preinstalled/current/ uses snap
# during cloud-init setup at first boot. Without this the login accounts are not
# created and the user can not login.
set_kernel_config CONFIG_SQUASHFS y

# Ceph support for Block Device (RBD) and Filesystem (FS)
# https://docs.ceph.com/docs/master/
set_kernel_config CONFIG_CEPH_LIB m
set_kernel_config CONFIG_CEPH_LIB_USE_DNS_RESOLVER y
set_kernel_config CONFIG_CEPH_FS m
set_kernel_config CONFIG_CEPH_FSCACHE y
set_kernel_config CONFIG_CEPH_FS_POSIX_ACL y
set_kernel_config CONFIG_BLK_DEV_RBD m

# Diffie-Hellman operations on retained keys
# (required for >keyutils-1.6)
set_kernel_config CONFIG_KEY_DH_OPERATIONS y


