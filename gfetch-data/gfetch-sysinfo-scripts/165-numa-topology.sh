#!/bin/bash
# 165-numa-topology.sh — NUMA node count and memory distribution

module_numa() {
    if [ -d /sys/devices/system/node ]; then
        local nodes=$(ls -d /sys/devices/system/node/node* 2>/dev/null | wc -l)
        if [ "$nodes" -gt 1 ]; then
            echo "⊞  NUMA:${nodes} nodes"
        else
            echo "⊞  NUMA:${nodes} node (UMA)"
        fi
    else
        echo "⊞  NUMA:N/A"
    fi
}

module_numa
