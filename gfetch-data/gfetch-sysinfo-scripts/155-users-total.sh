#!/bin/bash
# 155-users-total.sh — Total user accounts vs system accounts

module_user_accounts() {
    local total=$(wc -l < /etc/passwd)
    local human=$(awk -F: '$3 >= 1000 && $3 < 65534 {count++} END {print count+0}' /etc/passwd)
    local system=$((total - human))
    echo "  Accounts:${human} user/${system} sys"
}

module_user_accounts
