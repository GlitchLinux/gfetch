#!/bin/bash
# 126-mem-pressure.sh — Memory pressure stall info (PSI)

module_mem_pressure() {
    local psi="/proc/pressure/memory"
    if [ -f "$psi" ]; then
        local avg10=$(awk '/^some/ {print $2}' "$psi" | cut -d= -f2)
        if [ "$(echo "$avg10 > 10" | bc -l 2>/dev/null)" = "1" ]; then
            echo "󰍛  MemPressure:${avg10}% STALL"
        else
            echo "󰍛  MemPressure:${avg10}%"
        fi
    else
        echo "󰍛  MemPressure:N/A"
    fi
}

module_mem_pressure
