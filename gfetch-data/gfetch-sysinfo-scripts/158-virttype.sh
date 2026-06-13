#!/bin/bash
# 158-virttype.sh - Detailed virtualization platform detection
# Goes beyond bare "kvm/none" — identifies the specific hypervisor or container runtime.

module_virttype() {
    local virt="bare-metal"

    if command -v systemd-detect-virt &>/dev/null; then
        local raw
        raw=$(systemd-detect-virt 2>/dev/null)
        [ "$raw" != "none" ] && virt="$raw"
    elif [ -r /sys/hypervisor/type ]; then
        virt=$(cat /sys/hypervisor/type)
    elif grep -qi "VMware" /sys/class/dmi/id/sys_vendor 2>/dev/null; then
        virt="vmware"
    elif grep -qi "QEMU\|KVM" /proc/cpuinfo 2>/dev/null; then
        virt="kvm"
    elif [ -f /.dockerenv ]; then
        virt="docker"
    elif grep -q "lxc" /proc/1/environ 2>/dev/null; then
        virt="lxc"
    fi

    echo "󰢹  Virt:${virt}"
}

# Execute if run directly
module_virttype
