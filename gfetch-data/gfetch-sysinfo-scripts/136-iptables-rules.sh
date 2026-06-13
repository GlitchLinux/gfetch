#!/bin/bash
# 136-iptables-rules.sh — Total iptables/nftables rules loaded

module_fwrules() {
    local count=0
    if command -v iptables &>/dev/null; then
        count=$(iptables -S 2>/dev/null | wc -l)
    elif command -v nft &>/dev/null; then
        count=$(nft list ruleset 2>/dev/null | grep -c 'rule')
    fi
    echo "  FWRules:${count}"
}

module_fwrules
