#!/bin/bash
# 161-hostname-fqdn.sh — FQDN vs short hostname mismatch check

module_fqdn() {
    local short=$(hostname -s 2>/dev/null)
    local fqdn=$(hostname -f 2>/dev/null)
    if [ "$short" = "$fqdn" ] || [ -z "$fqdn" ]; then
        echo "  FQDN:${short} (no domain)"
    else
        echo "  FQDN:${fqdn}"
    fi
}

module_fqdn
