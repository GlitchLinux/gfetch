#!/bin/bash
# 166-numa-topology.sh - NUMA node count and per-node memory
# On multi-socket servers, NUMA mismatches silently kill performance.
# Single-node = fine; multi-node = worth knowing about.

module_numa_topology() {
    local nodes
    if command -v numactl &>/dev/null; then
        nodes=$(numactl --hardware 2>/dev/null | awk '/^available:/ {print $2}')
        if [ -z "$nodes" ] || [ "$nodes" -eq 1 ]; then
            echo "󰢮  NUMA:1 node (UMA)"
            return
        fi
        local mem_info
        mem_info=$(numactl --hardware 2>/dev/null | \
            awk '/^node [0-9]+ size:/ {printf "N%s:%sGB ", $2, int($4/1024)}')
        echo "󰢮  NUMA:${nodes} nodes — ${mem_info}"

    elif [ -d /sys/devices/system/node ]; then
        nodes=$(ls -d /sys/devices/system/node/node* 2>/dev/null | wc -l)
        if [ "$nodes" -le 1 ]; then
            echo "󰢮  NUMA:1 node (UMA)"
        else
            echo "󰢮  NUMA:${nodes} nodes"
        fi
    fi
}

# Execute if run directly
module_numa_topology
