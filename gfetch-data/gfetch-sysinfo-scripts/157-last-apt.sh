#!/bin/bash
# 157-last-apt.sh — Time since last apt update/upgrade

module_last_apt() {
    local stamp="/var/lib/apt/periodic/update-success-stamp"
    local alt="/var/cache/apt/pkgcache.bin"
    local target=""
    [ -f "$stamp" ] && target="$stamp"
    [ -z "$target" ] && [ -f "$alt" ] && target="$alt"
    if [ -n "$target" ]; then
        local mod=$(stat -c %Y "$target" 2>/dev/null)
        local now=$(date +%s)
        local hours=$(( (now - mod) / 3600 ))
        if [ "$hours" -gt 168 ]; then
            echo "  AptAge:${hours}h STALE"
        else
            echo "  AptAge:${hours}h"
        fi
    else
        echo "  AptAge:N/A"
    fi
}

module_last_apt
