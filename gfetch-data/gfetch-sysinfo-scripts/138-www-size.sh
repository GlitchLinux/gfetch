#!/bin/bash
# 138-www-size.sh — Total size of /var/www

module_www_size() {
    local size=$(du -sh /var/www 2>/dev/null | awk '{print $1}')
    echo "󰉋  WebRoot:${size:-N/A}"
}

module_www_size
