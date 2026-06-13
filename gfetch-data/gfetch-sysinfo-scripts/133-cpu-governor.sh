#!/bin/bash
# 133-cpu-governor.sh — CPU frequency scaling governor

module_governor() {
    local gov=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || echo "N/A")
    local freq=$(awk '{printf "%.0f", $1/1000}' /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq 2>/dev/null || echo "?")
    echo "󰓅  Governor:${gov} @${freq}MHz"
}

module_governor
