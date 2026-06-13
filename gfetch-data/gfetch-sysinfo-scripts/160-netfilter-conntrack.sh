#!/bin/bash
# 160-netfilter-conntrack.sh — Conntrack table usage (NAT/firewall state)

module_conntrack() {
    local cur=$(cat /proc/sys/net/netfilter/nf_conntrack_count 2>/dev/null || echo "0")
    local max=$(cat /proc/sys/net/netfilter/nf_conntrack_max 2>/dev/null || echo "0")
    if [ "$max" -gt 0 ]; then
        local pct=$((cur * 100 / max))
        if [ "$pct" -gt 75 ]; then
            echo "  Conntrack:${cur}/${max} (${pct}%) HIGH"
        else
            echo "  Conntrack:${cur}/${max} (${pct}%)"
        fi
    else
        echo "  Conntrack:N/A"
    fi
}

module_conntrack
