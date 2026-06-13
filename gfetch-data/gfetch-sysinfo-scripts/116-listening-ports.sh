#!/bin/bash
# 116-listening-ports.sh — Count of unique listening TCP/UDP ports

module_listen_ports() {
    local tcp=$(ss -tlnH 2>/dev/null | awk '{print $4}' | rev | cut -d: -f1 | rev | sort -un | wc -l)
    local udp=$(ss -ulnH 2>/dev/null | awk '{print $4}' | rev | cut -d: -f1 | rev | sort -un | wc -l)
    echo "  Ports:${tcp} tcp/${udp} udp"
}

module_listen_ports
