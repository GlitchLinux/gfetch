#!/bin/bash
# 144-zombie-hunter.sh — Hunt and identify zombie parent processes

module_zombie_hunter() {
    local zombies=$(ps aux 2>/dev/null | awk '$8=="Z"')
    local count=$(echo "$zombies" | grep -c . 2>/dev/null)
    if [ "${count:-0}" -gt 0 ]; then
        local parent_pid=$(echo "$zombies" | head -1 | awk '{print $2}')
        local ppid=$(ps -o ppid= -p "$parent_pid" 2>/dev/null | tr -d ' ')
        local pname=$(ps -o comm= -p "$ppid" 2>/dev/null)
        echo "󰊠  Zombies:${count} parent:${pname:-?}"
    else
        echo "󰊠  Zombies:0"
    fi
}

module_zombie_hunter
