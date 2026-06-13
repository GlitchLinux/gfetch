#!/bin/bash
# 129-largest-file.sh — Biggest file on the system (top-level scan)

module_largest_file() {
    local result=$(find / -maxdepth 4 -type f -printf '%s %p\n' 2>/dev/null | sort -rn | head -1)
    local size=$(echo "$result" | awk '{print $1}')
    local path=$(echo "$result" | awk '{print $2}' | sed 's|.*/||' | cut -c1-20)
    if [ -n "$size" ] && [ "$size" -gt 0 ]; then
        local human=$(awk "BEGIN {
            if ($size > 1073741824) printf \"%.1fG\", $size/1073741824
            else if ($size > 1048576) printf \"%.1fM\", $size/1048576
            else printf \"%.1fK\", $size/1024
        }")
        echo "󰪶  BigFile:${path} ${human}"
    else
        echo "󰪶  BigFile:N/A"
    fi
}

module_largest_file
