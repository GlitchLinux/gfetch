#!/bin/bash
# 124-cpu-power.sh — CPU package power draw (Intel RAPL)

module_cpu_power() {
    local rapl="/sys/class/powercap/intel-rapl:0/energy_uj"
    if [ -f "$rapl" ]; then
        local e1=$(cat "$rapl")
        sleep 1
        local e2=$(cat "$rapl")
        local watts=$(awk "BEGIN {printf \"%.1f\", ($e2 - $e1) / 1000000}")
        echo "󰚥  PkgPwr:${watts}W"
    else
        echo "󰚥  PkgPwr:N/A"
    fi
}

module_cpu_power
