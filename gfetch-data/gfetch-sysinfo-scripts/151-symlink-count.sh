#!/bin/bash
# 151-symlink-count.sh — Total symlinks under /etc

module_symlinks() {
    local count=$(find /etc -maxdepth 3 -type l 2>/dev/null | wc -l)
    echo "⊸  Symlinks:/etc ${count}"
}

module_symlinks
