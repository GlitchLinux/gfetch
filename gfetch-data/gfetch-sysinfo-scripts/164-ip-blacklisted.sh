#!/bin/bash
# 164-ip-blacklisted.sh — Check if WAN IP is on common blacklists

module_blacklist() {
    local ip=$(curl -s --max-time 3 ifconfig.me 2>/dev/null)
    if [ -z "$ip" ]; then
        echo "  Blacklist:N/A"
        return
    fi
    local rev=$(echo "$ip" | awk -F. '{print $4"."$3"."$2"."$1}')
    local listed=0
    local checked=0
    for bl in zen.spamhaus.org bl.spamcop.net b.barracudacentral.org; do
        checked=$((checked + 1))
        if host "${rev}.${bl}" &>/dev/null; then
            listed=$((listed + 1))
        fi
    done
    if [ "$listed" -gt 0 ]; then
        echo "  Blacklist:${listed}/${checked} LISTED"
    else
        echo "  Blacklist:clean (${checked})"
    fi
}

module_blacklist
