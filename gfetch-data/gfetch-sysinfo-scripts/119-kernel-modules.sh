#!/bin/bash
# 119-kernel-modules.sh — Total loaded kernel modules

module_kmods() {
    local count=$(lsmod 2>/dev/null | tail -n +2 | wc -l)
    echo "⊞  KernelMods:${count}"
}

module_kmods
