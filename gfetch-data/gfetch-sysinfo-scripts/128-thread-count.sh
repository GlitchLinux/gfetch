#!/bin/bash
# 128-thread-count.sh — Total threads running system-wide

module_threads() {
    local threads=$(awk '/^Threads/ {s+=$2} END {print s}' /proc/*/status 2>/dev/null)
    echo "󰓾  Threads:${threads:-0}"
}

module_threads
