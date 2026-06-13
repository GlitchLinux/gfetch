#!/bin/bash
# 130-systemd-units.sh — Loaded systemd unit breakdown

module_units() {
    local loaded=$(systemctl list-units --no-pager --no-legend 2>/dev/null | wc -l)
    local active=$(systemctl list-units --state=active --no-pager --no-legend 2>/dev/null | wc -l)
    local failed=$(systemctl list-units --state=failed --no-pager --no-legend 2>/dev/null | wc -l)
    if [ "$failed" -gt 0 ]; then
        echo "⚙  Units:${active}/${loaded} (${failed} failed)"
    else
        echo "⚙  Units:${active}/${loaded}"
    fi
}

module_units
