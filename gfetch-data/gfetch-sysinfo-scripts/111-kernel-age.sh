#!/bin/bash
# 111-kernel-age.sh — Days since kernel was compiled

module_kernel_age() {
    local kdate=$(uname -v 2>/dev/null | grep -oP '#\d+.*' | sed 's/#[0-9]* //')
    local kepoch=$(date -d "$kdate" +%s 2>/dev/null)
    local now=$(date +%s)
    if [ -n "$kepoch" ] && [ "$kepoch" -gt 0 ]; then
        local days=$(( (now - kepoch) / 86400 ))
        if [ "$days" -gt 180 ]; then
            echo "󰔚  Kernel Age:${days}d OLD"
        else
            echo "󰔚  Kernel Age:${days}d"
        fi
    else
        echo "󰔚  Kernel Age:N/A"
    fi
}

module_kernel_age
