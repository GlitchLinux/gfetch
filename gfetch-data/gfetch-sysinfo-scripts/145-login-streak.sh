#!/bin/bash
# 145-login-streak.sh — Consecutive days with SSH logins

module_login_streak() {
    local streak=0
    local today=$(date +%Y-%m-%d)
    for i in $(seq 0 365); do
        local day=$(date -d "$today - $i days" +%b\ %e 2>/dev/null | sed 's/  / /')
        if last 2>/dev/null | grep -q "$day"; then
            streak=$((streak + 1))
        else
            break
        fi
    done
    echo "󰈸  LoginStreak:${streak}d"
}

module_login_streak
