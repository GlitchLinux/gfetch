#!/bin/bash
# 114-disk-smart-age.sh — SMART power-on hours of primary disk

module_disk_age() {
    local disk=$(lsblk -dno NAME,TYPE 2>/dev/null | awk '$2=="disk" {print $1; exit}')
    if command -v smartctl &>/dev/null && [ -n "$disk" ]; then
        local hours=$(smartctl -A /dev/"$disk" 2>/dev/null | awk '/Power_On_Hours/ {print $NF}')
        if [ -n "$hours" ] && [ "$hours" -gt 0 ]; then
            local days=$((hours / 24))
            local years=$(awk "BEGIN {printf \"%.1f\", $days/365}")
            echo "󰋊  DiskAge:${hours}h (${years}y)"
            return
        fi
    fi
    echo "󰋊  DiskAge:N/A"
}

module_disk_age
