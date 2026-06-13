#!/bin/bash
# 134-network-errors.sh — NIC packet errors and drops

module_net_errors() {
    local iface=$(ip route show default 2>/dev/null | awk '{print $5; exit}')
    if [ -n "$iface" ]; then
        local rx_drop=$(cat /sys/class/net/"$iface"/statistics/rx_dropped 2>/dev/null || echo 0)
        local tx_drop=$(cat /sys/class/net/"$iface"/statistics/tx_dropped 2>/dev/null || echo 0)
        local rx_err=$(cat /sys/class/net/"$iface"/statistics/rx_errors 2>/dev/null || echo 0)
        local tx_err=$(cat /sys/class/net/"$iface"/statistics/tx_errors 2>/dev/null || echo 0)
        local total=$((rx_drop + tx_drop + rx_err + tx_err))
        if [ "$total" -gt 100 ]; then
            echo "󰅙  NICErr:${total} (${iface}) WARN"
        else
            echo "󰅙  NICErr:${total} (${iface})"
        fi
    else
        echo "󰅙  NICErr:N/A"
    fi
}

module_net_errors
