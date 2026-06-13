#!/bin/bash
# 135-page-faults.sh — Major page faults per second (disk thrashing indicator)

module_pgfaults() {
    local pf1=$(awk '/pgmajfault/ {print $2}' /proc/vmstat)
    sleep 1
    local pf2=$(awk '/pgmajfault/ {print $2}' /proc/vmstat)
    local rate=$((pf2 - pf1))
    if [ "$rate" -gt 10 ]; then
        echo "󰘨  PgFault:${rate}/s THRASH"
    else
        echo "󰘨  PgFault:${rate}/s"
    fi
}

module_pgfaults
