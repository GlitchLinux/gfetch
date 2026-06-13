#!/bin/bash
# 140-socket-count.sh — Total open sockets by type

module_sockets() {
    local tcp=$(ss -tH 2>/dev/null | wc -l)
    local udp=$(ss -uH 2>/dev/null | wc -l)
    local unix=$(ss -xH 2>/dev/null | wc -l)
    echo "⊙  Sockets:${tcp}tcp/${udp}udp/${unix}unix"
}

module_sockets
