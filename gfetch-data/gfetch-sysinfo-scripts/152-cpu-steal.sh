#!/bin/bash
# 152-cpu-steal.sh - CPU steal time % (time the hypervisor took back from this VM)
# Non-zero means you are on a VM being taxed by the host — closer to 0 is better.

module_cpu_steal() {
    local user nice system idle iowait irq softirq steal total steal_pct
    read -r _ user nice system idle iowait irq softirq steal _ < <(grep '^cpu ' /proc/stat)
    total=$(( user + nice + system + idle + iowait + irq + softirq + steal ))
    steal_pct=$(awk -v s="$steal" -v t="$total" \
        'BEGIN { if(t>0) printf "%.1f", s*100/t; else print "0.0" }')
    echo "󰘧  CPU Steal:${steal_pct}%"
}

# Execute if run directly
module_cpu_steal
