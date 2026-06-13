#!/bin/bash
# 156-journal-errors.sh - Systemd journal error and warning count since current boot
# Quick indicator that something in the system has been complaining.

module_journal_errors() {
    if ! command -v journalctl &>/dev/null; then
        return
    fi
    local errors warnings
    errors=$(journalctl -p err -b --no-pager -q 2>/dev/null | wc -l)
    warnings=$(journalctl -p warning..warning -b --no-pager -q 2>/dev/null | wc -l)
    echo "󱂅  Journal:${errors} err / ${warnings} warn (this boot)"
}

# Execute if run directly
module_journal_errors
