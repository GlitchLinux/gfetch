#!/bin/bash
# 155-systemd-timers.sh - Active systemd timers count and next-to-fire timer

module_systemd_timers() {
    if ! command -v systemctl &>/dev/null; then
        return
    fi
    local active next_timer next_in
    active=$(systemctl list-timers --no-legend 2>/dev/null | grep -c .)
    next_timer=$(systemctl list-timers --no-legend 2>/dev/null | head -1 | \
        awk '{for(i=1;i<=NF;i++) if($i ~ /\.timer$/) {print $i; exit}}')
    next_in=$(systemctl list-timers --no-legend 2>/dev/null | head -1 | \
        awk '{print $1, $2}')

    if [ -n "$next_timer" ]; then
        echo "󰃰  Timers:${active} active / next: ${next_timer}"
    else
        echo "󰃰  Timers:${active} active"
    fi
}

# Execute if run directly
module_systemd_timers
