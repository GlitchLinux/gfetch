#!/bin/bash
# 127-io-pressure.sh — I/O pressure stall info (PSI)

module_io_pressure() {
    local psi="/proc/pressure/io"
    if [ -f "$psi" ]; then
        local avg10=$(awk '/^some/ {print $2}' "$psi" | cut -d= -f2)
        if [ "$(echo "$avg10 > 20" | bc -l 2>/dev/null)" = "1" ]; then
            echo "󰋊  IOPressure:${avg10}% STALL"
        else
            echo "󰋊  IOPressure:${avg10}%"
        fi
    else
        echo "󰋊  IOPressure:N/A"
    fi
}

module_io_pressure
