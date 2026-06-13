#!/bin/bash
# 137-dmesg-errors.sh — Kernel ring buffer errors since boot

module_dmesg_err() {
    local errors=$(dmesg --level=err,crit,alert,emerg 2>/dev/null | wc -l)
    local warns=$(dmesg --level=warn 2>/dev/null | wc -l)
    if [ "$errors" -gt 0 ]; then
        echo "󱂅  Dmesg:${errors} err/${warns} warn"
    else
        echo "󱂅  Dmesg:clean/${warns} warn"
    fi
}

module_dmesg_err
