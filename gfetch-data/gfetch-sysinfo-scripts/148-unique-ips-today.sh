#!/bin/bash
# 148-unique-ips-today.sh — Unique IPs that hit Apache today

module_unique_ips() {
    local log="/var/log/apache2/access.log"
    local today=$(date '+%d/%b/%Y')
    if [ -f "$log" ]; then
        local count=$(grep "$today" "$log" 2>/dev/null | awk '{print $1}' | sort -u | wc -l)
        echo "󰖟  UniqueIPs:${count} today"
    else
        echo "󰖟  UniqueIPs:N/A"
    fi
}

module_unique_ips
