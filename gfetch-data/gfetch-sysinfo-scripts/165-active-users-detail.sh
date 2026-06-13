#!/bin/bash
# 165-active-users-detail.sh - Active user sessions with tty and login time
# Who is actually on the box right now, and from where?

module_active_users_detail() {
    if ! command -v who &>/dev/null; then
        return
    fi
    local count sessions
    count=$(who 2>/dev/null | wc -l)

    if [ "$count" -eq 0 ]; then
        echo "󰀄  Active Users:none"
        return
    fi

    # Compact: "root(tty1) user@1.2.3.4(pts/0)"
    sessions=$(who 2>/dev/null | awk '{
        user=$1; tty=$2; from=$5
        gsub(/[()]/,"",from)
        if (from != "") printf "%s@%s(%s) ", user, from, tty
        else printf "%s(%s) ", user, tty
    }' | sed 's/  *$//')

    echo "󰀄  Active Users:${count} → ${sessions}"
}

# Execute if run directly
module_active_users_detail
