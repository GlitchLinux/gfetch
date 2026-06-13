#!/bin/bash
# 143-wordcount-etc.sh — Total config lines in /etc

module_etc_lines() {
    local lines=$(find /etc -maxdepth 2 -name '*.conf' -exec cat {} + 2>/dev/null | wc -l)
    if [ "$lines" -ge 1000 ]; then
        local k=$(awk "BEGIN {printf \"%.1f\", $lines/1000}")
        echo "󰈙  ConfLines:${k}K"
    else
        echo "󰈙  ConfLines:${lines}"
    fi
}

module_etc_lines
