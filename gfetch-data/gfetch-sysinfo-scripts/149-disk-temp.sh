#!/bin/bash
# 149-disk-temp.sh — Disk temperature via SMART or hddtemp

module_disk_temp() {
    local disk=$(lsblk -dno NAME,TYPE 2>/dev/null | awk '$2=="disk" {print $1; exit}')
    if command -v smartctl &>/dev/null && [ -n "$disk" ]; then
        local temp=$(smartctl -A /dev/"$disk" 2>/dev/null | awk '/Temperature_Celsius|Airflow_Temperature/ {print $NF; exit}')
        if [ -n "$temp" ] && [ "$temp" -gt 0 ]; then
            if [ "$temp" -ge 50 ]; then
                echo "󰔏  DiskTemp:${temp}°C HOT"
            else
                echo "󰔏  DiskTemp:${temp}°C"
            fi
            return
        fi
    fi
    echo "󰔏  DiskTemp:N/A"
}

module_disk_temp
