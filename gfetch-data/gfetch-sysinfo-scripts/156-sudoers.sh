#!/bin/bash
# 156-sudoers.sh — Users with sudo privileges

module_sudoers() {
    local count=0
    # Check /etc/sudoers and sudoers.d
    if [ -f /etc/sudoers ]; then
        count=$(grep -cE '^[^#].*ALL=.*ALL' /etc/sudoers /etc/sudoers.d/* 2>/dev/null)
    fi
    # Also check sudo group members
    local grp=$(getent group sudo 2>/dev/null | cut -d: -f4 | tr ',' '\n' | grep -c .)
    echo "  Sudoers:${count} rules/${grp} members"
}

module_sudoers
