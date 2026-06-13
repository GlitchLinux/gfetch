#!/bin/bash
# 121-swap-pressure.sh — Swap in/out rate per second

module_swap_pressure() {
    local si1=$(awk '/pswpin/ {print $2}' /proc/vmstat)
    local so1=$(awk '/pswpout/ {print $2}' /proc/vmstat)
    sleep 1
    local si2=$(awk '/pswpin/ {print $2}' /proc/vmstat)
    local so2=$(awk '/pswpout/ {print $2}' /proc/vmstat)
    local sin=$((si2 - si1))
    local sout=$((so2 - so1))
    if [ "$sin" -gt 0 ] || [ "$sout" -gt 0 ]; then
        echo "⇅  SwapIO:${sin}in/${sout}out pg/s"
    else
        echo "⇅  SwapIO:idle"
    fi
}

module_swap_pressure
