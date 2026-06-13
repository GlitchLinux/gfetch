#!/bin/bash
# 109-inode-usage.sh — Inode usage on root filesystem

module_inode() {
    local info=$(df -i / 2>/dev/null | tail -1)
    local used=$(echo "$info" | awk '{print $3}')
    local total=$(echo "$info" | awk '{print $2}')
    local pct=$(echo "$info" | awk '{print $5}')
    if [ "${pct%\%}" -ge 80 ]; then
        echo "󰈤  Inodes:${pct} WARN"
    else
        echo "󰈤  Inodes:${pct}"
    fi
}

module_inode
