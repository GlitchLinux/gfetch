#!/bin/bash
# 157-podman.sh - Podman container stats (running/total) — rootless-friendly

module_podman() {
    if ! command -v podman &>/dev/null; then
        return
    fi
    local running total
    running=$(podman ps -q 2>/dev/null | wc -l)
    total=$(podman ps -aq 2>/dev/null | wc -l)
    echo "󰡨  Podman:${running}/${total}"
}

# Execute if run directly
module_podman
