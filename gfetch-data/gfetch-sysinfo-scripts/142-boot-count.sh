#!/bin/bash
# 142-boot-count.sh — Total system boots (persistent counter)

BOOT_FILE="/var/lib/sysinfo-boot-count"

module_boot_count() {
    local bootid=$(cat /proc/sys/kernel/random/boot_id 2>/dev/null)
    local lastid=""
    local count=0
    if [ -f "$BOOT_FILE" ]; then
        lastid=$(head -1 "$BOOT_FILE" 2>/dev/null)
        count=$(tail -1 "$BOOT_FILE" 2>/dev/null)
    fi
    if [ "$bootid" != "$lastid" ]; then
        count=$((count + 1))
        printf '%s\n%s\n' "$bootid" "$count" > "$BOOT_FILE" 2>/dev/null
    fi
    echo "󰜉  Boots:${count}"
}

module_boot_count
