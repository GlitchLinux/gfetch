#!/bin/bash
# 106-interrupts.sh — Hardware interrupts per second

module_interrupts() {
    local i1=$(awk '/^CPU|^[0-9]/' /proc/interrupts | tail -n +2 | awk '{s+=$2} END {print s+0}')
    sleep 1
    local i2=$(awk '/^CPU|^[0-9]/' /proc/interrupts | tail -n +2 | awk '{s+=$2} END {print s+0}')
    local rate=$((i2 - i1))
    if [ "$rate" -ge 1000 ]; then
        echo "⚡  IRQ:$(awk "BEGIN {printf \"%.1fK\", $rate/1000}")/s"
    else
        echo "⚡  IRQ:${rate}/s"
    fi
}

module_interrupts
