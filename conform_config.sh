#!/bin/bash
#
# Simple script to tweak an existing baseline kernel .config file.
#
# Copyright (c) 2018 sakaki <sakaki@deciban.com>
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
