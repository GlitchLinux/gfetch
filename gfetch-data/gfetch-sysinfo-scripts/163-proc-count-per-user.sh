#!/bin/bash
# 163-proc-count-per-user.sh — Top process-owning user

module_proc_top_user() {
    local info=$(ps -eo user= 2>/dev/null | sort | uniq -c | sort -rn | head -1)
    local count=$(echo "$info" | awk '{print $1}')
    local user=$(echo "$info" | awk '{print $2}')
    echo "  TopUser:${user} (${count} procs)"
}

module_proc_top_user
