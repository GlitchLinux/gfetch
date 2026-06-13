#!/bin/bash
# 122-dns-latency.sh — Current nameserver + response time

module_dns() {
    local ns=$(awk '/^nameserver/ {print $2; exit}' /etc/resolv.conf 2>/dev/null)
    if [ -n "$ns" ] && command -v dig &>/dev/null; then
        local ms=$(dig @"$ns" google.com +noall +stats 2>/dev/null | awk '/Query time/ {print $4}')
        echo "󰇖  DNS:${ns} ${ms:-?}ms"
    elif [ -n "$ns" ]; then
        echo "󰇖  DNS:${ns}"
    else
        echo "󰇖  DNS:N/A"
    fi
}

module_dns
