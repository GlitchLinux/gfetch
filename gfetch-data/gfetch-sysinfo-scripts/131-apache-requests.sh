#!/bin/bash
# 131-apache-requests.sh — Apache requests in last 5 minutes

module_apache_req() {
    local log="/var/log/apache2/access.log"
    if [ -f "$log" ]; then
        local five_min_ago=$(date -d '5 minutes ago' '+%d/%b/%Y:%H:%M' 2>/dev/null)
        local count=$(awk -v t="$five_min_ago" '$4 >= "["t' "$log" 2>/dev/null | wc -l)
        echo "󰖟  WebReq:${count}/5m"
    else
        echo "󰖟  WebReq:N/A"
    fi
}

module_apache_req
