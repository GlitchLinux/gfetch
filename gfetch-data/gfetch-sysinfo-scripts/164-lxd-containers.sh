#!/bin/bash
# 164-lxd-containers.sh - LXD/LXC container stats (running/total)

module_lxd() {
    if command -v lxc &>/dev/null && lxc list &>/dev/null 2>&1; then
        local running total
        running=$(lxc list 2>/dev/null | awk '/RUNNING/ {count++} END {print count+0}')
        total=$(lxc list 2>/dev/null | grep -cE "^\|[[:space:]]+[a-zA-Z]")
        echo "󰡨  LXD:${running}/${total} running"
        return
    fi

    # Fallback: bare lxc-ls (LXC without LXD)
    if command -v lxc-ls &>/dev/null; then
        local running total
        running=$(lxc-ls --running 2>/dev/null | wc -w)
        total=$(lxc-ls 2>/dev/null | wc -w)
        [ "$total" -gt 0 ] && echo "󰡨  LXC:${running}/${total} running"
    fi
}

# Execute if run directly
module_lxd
