#!/bin/bash
# 107-open-files.sh — Total open file descriptors system-wide

module_open_files() {
    local open=$(cat /proc/sys/fs/file-nr 2>/dev/null | awk '{print $1}')
    local max=$(cat /proc/sys/fs/file-nr 2>/dev/null | awk '{print $3}')
    local pct=$((open * 100 / max))
    echo "󰈔  OpenFDs:${open} (${pct}%)"
}

module_open_files
