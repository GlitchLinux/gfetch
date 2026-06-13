#!/bin/bash
# 167-permabanned.sh — Count of permanently banned SSH IPs

module_permabanned() {
    local banlist="/etc/ssh/permabanned.list"
    if [ -f "$banlist" ]; then
        local count=$(wc -l < "$banlist")
        local latest=$(tail -1 "$banlist" | awk '{print $1}')
        if [ "$count" -gt 0 ]; then
            echo "󰒃  Permabanned:${count} IPs (last:${latest})"
        else
            echo "󰒃  Permabanned:0"
        fi
    else
        echo "󰒃  Permabanned:0"
    fi
}

module_permabanned
