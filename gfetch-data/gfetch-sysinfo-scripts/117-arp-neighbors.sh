#!/bin/bash
# 117-arp-neighbors.sh — Devices visible on local network

module_arp() {
    local count=$(ip neigh show 2>/dev/null | grep -cv FAILED)
    echo "󰩟  ARPNeighbors:${count}"
}

module_arp
