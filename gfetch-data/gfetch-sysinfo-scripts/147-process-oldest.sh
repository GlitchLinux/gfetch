#!/bin/bash
# 147-process-oldest.sh — Longest running non-kernel process

module_oldest_proc() {
    local info=$(ps -eo etimes,comm --sort=-etimes 2>/dev/null | awk 'NR==2 {print $1, $2}')
    local secs=$(echo "$info" | awk '{print $1}')
    local name=$(echo "$info" | awk '{print $2}' | cut -c1-16)
    if [ -n "$secs" ] && [ "$secs" -gt 0 ]; then
        local days=$((secs / 86400))
        local hours=$(( (secs % 86400) / 3600 ))
        if [ "$days" -gt 0 ]; then
            echo "󰔚  Eldest:${name} ${days}d${hours}h"
        else
            echo "󰔚  Eldest:${name} ${hours}h"
        fi
    else
        echo "󰔚  Eldest:N/A"
    fi
}

module_oldest_proc
