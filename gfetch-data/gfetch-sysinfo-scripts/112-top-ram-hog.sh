#!/bin/bash
# 112-top-ram-hog.sh — Process consuming the most RAM

module_top_ram() {
    local info=$(ps aux --sort=-%mem 2>/dev/null | awk 'NR==2 {printf "%s %.1f%%", $11, $4}')
    local name=$(echo "$info" | awk '{print $1}' | sed 's|.*/||' | cut -c1-16)
    local pct=$(echo "$info" | awk '{print $2}')
    echo "󰓡  RamHog:${name} ${pct}"
}

module_top_ram
