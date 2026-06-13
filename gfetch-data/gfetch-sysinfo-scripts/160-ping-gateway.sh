#!/bin/bash
# 160-ping-gateway.sh - Round-trip latency to the default gateway
# Immediate sanity check: is the local network sane, and at what cost?

module_ping_gateway() {
    local gw rtt
    gw=$(ip route show default 2>/dev/null | awk '/^default/ {print $3; exit}')
    [ -z "$gw" ] && return

    rtt=$(ping -c 1 -W 2 "$gw" 2>/dev/null | \
        awk -F'/' '/^rtt/ {printf "%.1f", $5}')

    if [ -n "$rtt" ]; then
        echo "󰑩  GW Ping:${rtt}ms → ${gw}"
    else
        echo "󰑩  GW Ping:timeout → ${gw}"
    fi
}

# Execute if run directly
module_ping_gateway
