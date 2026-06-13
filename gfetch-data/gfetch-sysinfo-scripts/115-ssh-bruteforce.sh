#!/bin/bash
# 115-ssh-bruteforce.sh — Failed SSH auth attempts in last 24h

module_ssh_brute() {
    local count=0
    if [ -f /var/log/auth.log ]; then
        count=$(grep -c "Failed password" /var/log/auth.log 2>/dev/null || echo "0")
    elif command -v journalctl &>/dev/null; then
        # Try both unit names: "ssh" (Debian) and "sshd" (RHEL/Arch)
        count=$(journalctl --no-pager -u ssh -u sshd --since "24 hours ago" -q 2>/dev/null | grep -c "Failed password")
    fi
    if [ "$count" -gt 100 ]; then
        echo "󰒃  SSHFail:${count}/24h HEAVY"
    elif [ "$count" -gt 0 ]; then
        echo "󰒃  SSHFail:${count}/24h"
    else
        echo "󰒃  SSHFail:0/24h"
    fi
}

module_ssh_brute
