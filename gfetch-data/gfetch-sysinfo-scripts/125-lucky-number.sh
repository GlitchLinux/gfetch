#!/bin/bash
# 125-lucky-number.sh — Random lucky number from /dev/urandom

module_lucky() {
    local num=$(od -An -tu4 -N4 /dev/urandom 2>/dev/null | tr -d ' ')
    local lucky=$((num % 1000))
    echo "⚄  Lucky#:${lucky}"
}

module_lucky
