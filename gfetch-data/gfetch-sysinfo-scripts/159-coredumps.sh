#!/bin/bash
# 159-coredumps.sh — Core dumps stored by systemd-coredump

module_coredumps() {
    if command -v coredumpctl &>/dev/null; then
        local count=$(coredumpctl list --no-pager 2>/dev/null | tail -n +2 | wc -l)
        if [ "$count" -gt 0 ]; then
            local latest=$(coredumpctl list --no-pager 2>/dev/null | tail -1 | awk '{print $NF}')
            echo "  CoreDumps:${count} last:${latest}"
        else
            echo "  CoreDumps:0"
        fi
    else
        local count=$(find /var/crash /var/lib/systemd/coredump -name 'core*' 2>/dev/null | wc -l)
        echo "  CoreDumps:${count}"
    fi
}

module_coredumps
