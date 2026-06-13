#!/bin/bash
# 108-tcp-connections.sh — Active TCP connection states

module_tcp() {
    local estab=$(ss -t state established 2>/dev/null | tail -n +2 | wc -l)
    local wait=$(ss -t state time-wait 2>/dev/null | tail -n +2 | wc -l)
    local listen=$(ss -tln 2>/dev/null | tail -n +2 | wc -l)
    echo "󰌘  TCP:${estab} est/${listen} listen/${wait} tw"
}

module_tcp
