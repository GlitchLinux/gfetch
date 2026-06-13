#!/bin/bash
# 113-top-cpu-hog.sh — Process consuming the most CPU

module_top_cpu() {
    local info=$(ps aux --sort=-%cpu 2>/dev/null | awk 'NR==2 {printf "%s %.1f%%", $11, $3}')
    local name=$(echo "$info" | awk '{print $1}' | sed 's|.*/||' | cut -c1-16)
    local pct=$(echo "$info" | awk '{print $2}')
    echo "󰻠  CpuHog:${name} ${pct}"
}

module_top_cpu
