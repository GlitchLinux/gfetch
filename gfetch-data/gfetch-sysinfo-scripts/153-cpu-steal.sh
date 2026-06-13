#!/bin/bash
# 153-cpu-steal.sh — CPU steal time (VM overhead indicator)

module_steal() {
    local steal=$(awk '/^cpu / {printf "%.1f", $9/($2+$3+$4+$5+$6+$7+$8+$9+$10)*100}' /proc/stat 2>/dev/null)
    if [ "$(echo "$steal > 5" | bc -l 2>/dev/null)" = "1" ]; then
        echo "  CpuSteal:${steal}% HIGH"
    else
        echo "  CpuSteal:${steal}%"
    fi
}

module_steal
