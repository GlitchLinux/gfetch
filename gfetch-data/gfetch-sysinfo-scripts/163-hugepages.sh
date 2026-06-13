#!/bin/bash
# 163-hugepages.sh - HugePages allocation and usage
# Databases (Postgres, Oracle) and VMs (QEMU/KVM) love huge pages for TLB efficiency.

module_hugepages() {
    local total free size used
    total=$(awk '/^HugePages_Total:/ {print $2}' /proc/meminfo)
    free=$(awk  '/^HugePages_Free:/  {print $2}' /proc/meminfo)
    size=$(awk  '/^Hugepagesize:/    {printf "%dMB", $2/1024}' /proc/meminfo)

    [ -z "$total" ] || [ "$total" -eq 0 ] && echo "󰍛  HugePages:disabled" && return

    used=$(( total - free ))
    echo "󰍛  HugePages:${used}/${total} used (${size} each)"
}

# Execute if run directly
module_hugepages
