#!/bin/bash
# 158-journal-size.sh — Systemd journal disk usage

module_journal() {
    local size=$(journalctl --disk-usage 2>/dev/null | grep -oP '[\d.]+[KMGT]')
    echo "  Journal:${size:-N/A}"
}

module_journal
