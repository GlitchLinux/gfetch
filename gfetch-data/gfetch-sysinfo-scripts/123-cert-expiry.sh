#!/bin/bash
# 123-cert-expiry.sh — Nearest SSL certificate expiration (Apache sites)

module_cert() {
    local earliest=""
    local earliest_days=99999
    local earliest_domain=""
    for cert in /etc/letsencrypt/live/*/cert.pem; do
        [ -f "$cert" ] || continue
        local domain=$(basename "$(dirname "$cert")")
        local expiry=$(openssl x509 -enddate -noout -in "$cert" 2>/dev/null | cut -d= -f2)
        local exp_epoch=$(date -d "$expiry" +%s 2>/dev/null)
        local now=$(date +%s)
        local days=$(( (exp_epoch - now) / 86400 ))
        if [ "$days" -lt "$earliest_days" ]; then
            earliest_days=$days
            earliest_domain=$domain
        fi
    done
    if [ "$earliest_days" -lt 99999 ]; then
        if [ "$earliest_days" -lt 14 ]; then
            echo "󰌋  CertExp:${earliest_domain} ${earliest_days}d RENEW"
        else
            echo "󰌋  CertExp:${earliest_domain} ${earliest_days}d"
        fi
    else
        echo "󰌋  CertExp:N/A"
    fi
}

module_cert
