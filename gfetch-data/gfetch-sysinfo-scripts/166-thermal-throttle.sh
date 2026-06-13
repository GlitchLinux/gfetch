#!/bin/bash
# 166-thermal-throttle.sh — CPU thermal throttle events since boot

module_throttle() {
    local count=0
    for cpu in /sys/devices/system/cpu/cpu*/thermal_throttle/core_throttle_count; do
        [ -f "$cpu" ] && count=$((count + $(cat "$cpu" 2>/dev/null)))
    done
    if [ "$count" -gt 0 ]; then
        echo "  Throttled:${count} events"
    else
        echo "  Throttled:0"
    fi
}

module_throttle
