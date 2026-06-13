#!/bin/bash
# 151-cpu-freq.sh - Current CPU clock frequency

module_cpu_freq() {
    local freq_khz freq_ghz
    if [ -r /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq ]; then
        freq_khz=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq)
        freq_ghz=$(awk -v f="$freq_khz" 'BEGIN {printf "%.2f", f/1000000}')
        echo "󰓅  CPU Freq:${freq_ghz}GHz"
    elif command -v lscpu &>/dev/null; then
        freq_ghz=$(lscpu | awk '/CPU MHz/ {printf "%.2f", $3/1000}')
        [ -n "$freq_ghz" ] && echo "󰓅  CPU Freq:${freq_ghz}GHz"
    fi
}

# Execute if run directly
module_cpu_freq
