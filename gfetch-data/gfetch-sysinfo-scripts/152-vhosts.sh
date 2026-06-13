#!/bin/bash
# 152-vhosts.sh — Active Apache virtual hosts

module_vhosts() {
    local count=0
    if command -v apache2ctl &>/dev/null; then
        count=$(apache2ctl -S 2>/dev/null | grep -c 'namevhost')
    elif command -v httpd &>/dev/null; then
        count=$(httpd -S 2>/dev/null | grep -c 'namevhost')
    fi
    echo "  VHosts:${count}"
}

module_vhosts
