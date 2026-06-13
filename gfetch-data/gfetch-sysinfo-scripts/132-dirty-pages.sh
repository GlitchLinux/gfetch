#!/bin/bash
# 132-dirty-pages.sh — Kernel dirty memory pages awaiting writeback

module_dirty() {
    local dirty=$(awk '/^Dirty:/ {print $2}' /proc/meminfo 2>/dev/null)
    local wb=$(awk '/^Writeback:/ {print $2}' /proc/meminfo 2>/dev/null)
    if [ "${dirty:-0}" -gt 102400 ]; then
        echo "󰏗  Dirty:$((dirty/1024))M wb:$((wb/1024))M HIGH"
    else
        echo "󰏗  Dirty:$((dirty/1024))M wb:$((wb/1024))M"
    fi
}

module_dirty
