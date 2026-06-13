#!/bin/bash
# 110-last-login.sh — Most recent login (non-current)

module_last_login() {
    local info=$(last -n 2 -w 2>/dev/null | head -2 | tail -1)
    local user=$(echo "$info" | awk '{print $1}')
    local when=$(echo "$info" | awk '{print $5, $6, $7}')
    if [ -n "$user" ] && [ "$user" != "reboot" ]; then
        echo "󰀄  LastLogin:${user} ${when}"
    else
        echo "󰀄  LastLogin:none"
    fi
}

module_last_login
