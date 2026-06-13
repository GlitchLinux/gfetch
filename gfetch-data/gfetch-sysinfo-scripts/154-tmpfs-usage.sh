#!/bin/bash
# 154-tmpfs-usage.sh — Total tmpfs memory consumed

module_tmpfs() {
    local used=$(df -t tmpfs --total 2>/dev/null | awk '/^total/ {print $3}')
    if [ -n "$used" ] && [ "$used" -gt 0 ]; then
        local mb=$((used / 1024))
        echo "  Tmpfs:${mb}M used"
    else
        echo "  Tmpfs:0M"
    fi
}

module_tmpfs
