#!/bin/bash
# 141-uptime-record.sh — Longest uptime ever vs current (persistent tracker)

RECORD_FILE="/var/lib/sysinfo-uptime-record"

module_uptime_record() {
    local current=$(cat /proc/uptime | cut -d. -f1)
    local record=0
    [ -f "$RECORD_FILE" ] && record=$(cat "$RECORD_FILE" 2>/dev/null)
    if [ "$current" -gt "${record:-0}" ]; then
        echo "$current" > "$RECORD_FILE" 2>/dev/null
        record=$current
        local days=$((current / 86400))
        echo "󰄉  UptimeRecord:${days}d NEW"
    else
        local cur_d=$((current / 86400))
        local rec_d=$((record / 86400))
        echo "󰄉  UptimeRecord:${cur_d}d/${rec_d}d best"
    fi
}

module_uptime_record
