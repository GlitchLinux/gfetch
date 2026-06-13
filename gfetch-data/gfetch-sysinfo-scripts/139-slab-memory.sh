#!/bin/bash
# 139-slab-memory.sh — Kernel slab allocator memory usage

module_slab() {
    local slab=$(awk '/^Slab:/ {printf "%.0f", $2/1024}' /proc/meminfo 2>/dev/null)
    local reclaimable=$(awk '/^SReclaimable:/ {printf "%.0f", $2/1024}' /proc/meminfo 2>/dev/null)
    echo "󰍛  Slab:${slab:-0}M (${reclaimable:-0}M reclaimable)"
}

module_slab
