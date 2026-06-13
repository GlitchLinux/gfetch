#!/bin/bash
# 161-last-pkg.sh - Most recently installed/upgraded package
# Fun audit trail: what was the last thing changed on this system?

module_last_pkg() {
    # Debian / Ubuntu — dpkg log
    if [ -r /var/log/dpkg.log ]; then
        local pkg when action
        read -r _ _ action pkg _ < <(grep " install \| upgrade " /var/log/dpkg.log 2>/dev/null | tail -1)
        when=$(grep " install \| upgrade " /var/log/dpkg.log 2>/dev/null | tail -1 | awk '{print $1, $2}')
        [ -n "$pkg" ] && echo "󰏖  Last Pkg:${pkg} (${action} ${when})" && return
    fi

    # RPM-based — rpm query
    if command -v rpm &>/dev/null; then
        local entry
        entry=$(rpm -qa --qf '%{INSTALLTIME:date} %{NAME}-%{VERSION}\n' 2>/dev/null | sort | tail -1)
        [ -n "$entry" ] && echo "󰏖  Last Pkg:${entry}" && return
    fi

    # Arch — pacman log
    if [ -r /var/log/pacman.log ]; then
        local entry
        entry=$(grep "installed\|upgraded" /var/log/pacman.log 2>/dev/null | tail -1 | \
            awk '{print $4, $5}')
        [ -n "$entry" ] && echo "󰏖  Last Pkg:${entry}" && return
    fi
}

# Execute if run directly
module_last_pkg
