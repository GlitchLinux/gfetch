#!/bin/bash
# 153-pending-reboot.sh - Check whether a system reboot is currently required
# Debian/Ubuntu write a flag file after kernel/libc upgrades; checks that + running kernel vs installed.

module_pending_reboot() {
    local flag_file="/var/run/reboot-required"
    local pkgs_file="/var/run/reboot-required.pkgs"

    if [ -f "$flag_file" ]; then
        if [ -f "$pkgs_file" ]; then
            local n
            n=$(wc -l < "$pkgs_file")
            echo "󰜉  Reboot Needed (${n} pkg(s))"
        else
            echo "󰜉  Reboot Needed"
        fi
        return
    fi

    # Fallback: compare running kernel with latest installed (Debian/Ubuntu)
    if command -v dpkg &>/dev/null; then
        local running installed
        running=$(uname -r)
        installed=$(dpkg -l 'linux-image-*' 2>/dev/null | awk '/^ii/ {print $3}' | \
            sed 's/.*linux-image-//' | sort -V | tail -1)
        if [ -n "$installed" ] && [ "$running" != "$installed" ]; then
            echo "󰜉  Reboot Needed (kernel ${running} → ${installed})"
            return
        fi
    fi

    echo "󰄬  No Reboot Needed"
}

# Execute if run directly
module_pending_reboot
