#!/bin/bash
# 120-oom-kills.sh — Out-of-memory kills since boot

module_oom() {
    local count=0
    if [ -f /proc/vmstat ]; then
        count=$(awk '/oom_kill/ {print $2}' /proc/vmstat 2>/dev/null)
    fi
    if [ "${count:-0}" -gt 0 ]; then
        echo "☠  OOM Kills:${count}"
    else
        echo "☠  OOM Kills:0"
    fi
}

module_oom
