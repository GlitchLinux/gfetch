#!/bin/bash
# 104-entropy.sh — Available kernel entropy pool

module_entropy() {
    local entropy=$(cat /proc/sys/kernel/random/entropy_avail 2>/dev/null || echo "0")
    local pool=$(cat /proc/sys/kernel/random/poolsize 2>/dev/null || echo "256")
    if [ "$entropy" -lt 200 ]; then
        echo "󰗊  Entropy:${entropy}/${pool} LOW"
    else
        echo "󰗊  Entropy:${entropy}/${pool}"
    fi
}

module_entropy
