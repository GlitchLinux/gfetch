#!/bin/bash
# 105-context-switches.sh — Kernel context switches per second

module_ctx_switches() {
    local cs1=$(awk '/ctxt/ {print $2}' /proc/stat)
    sleep 1
    local cs2=$(awk '/ctxt/ {print $2}' /proc/stat)
    local rate=$((cs2 - cs1))
    if [ "$rate" -ge 1000000 ]; then
        echo "⇄  CtxSw:$(awk "BEGIN {printf \"%.1fM\", $rate/1000000}")/s"
    elif [ "$rate" -ge 1000 ]; then
        echo "⇄  CtxSw:$(awk "BEGIN {printf \"%.1fK\", $rate/1000}")/s"
    else
        echo "⇄  CtxSw:${rate}/s"
    fi
}

module_ctx_switches
