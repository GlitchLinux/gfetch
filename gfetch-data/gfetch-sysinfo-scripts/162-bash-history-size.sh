#!/bin/bash
# 162-bash-history-size.sh — Lines in current user's bash history

module_hist() {
    local file="${HOME}/.bash_history"
    if [ -f "$file" ]; then
        local lines=$(wc -l < "$file")
        echo "  History:${lines} cmds"
    else
        echo "  History:0 cmds"
    fi
}

module_hist
