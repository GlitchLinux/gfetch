#!/bin/bash
# 146-time-drift.sh — System clock drift from NTP reference

module_drift() {
    if command -v timedatectl &>/dev/null; then
        local synced=$(timedatectl show -p NTPSynchronized --value 2>/dev/null)
        if [ "$synced" = "yes" ]; then
            if command -v chronyc &>/dev/null; then
                local offset=$(chronyc tracking 2>/dev/null | awk '/Last offset/ {printf "%.3f", $4*1000}')
                echo "󰥔  Drift:${offset:-0}ms (synced)"
            else
                echo "󰥔  Drift:synced"
            fi
        else
            echo "󰥔  Drift:NOT SYNCED"
        fi
    else
        echo "󰥔  Drift:N/A"
    fi
}

module_drift
