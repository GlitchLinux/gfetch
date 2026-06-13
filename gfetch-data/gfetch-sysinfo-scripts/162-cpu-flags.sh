#!/bin/bash
# 162-cpu-flags.sh - Notable CPU instruction set extensions
# Shows which power features your CPU supports: crypto acceleration, vector ops, VM extensions.

module_cpu_flags() {
    if [ ! -r /proc/cpuinfo ]; then
        return
    fi
    local flags supported=()

    flags=$(grep -m1 '^flags' /proc/cpuinfo | cut -d: -f2)

    # Security / crypto acceleration
    echo "$flags" | grep -qw "aes"     && supported+=("AES-NI")
    echo "$flags" | grep -qw "sha_ni"  && supported+=("SHA-NI")

    # Virtualisation support
    echo "$flags" | grep -qw "vmx"     && supported+=("VT-x")
    echo "$flags" | grep -qw "svm"     && supported+=("AMD-V")

    # Vector / SIMD
    echo "$flags" | grep -qw "avx512f" && supported+=("AVX-512")
    echo "$flags" | grep -qw "avx2"    && supported+=("AVX2")
    echo "$flags" | grep -qw "avx"     && ! echo "$flags" | grep -qw "avx2" && supported+=("AVX")
    echo "$flags" | grep -qw "sse4_2"  && supported+=("SSE4.2")

    # Misc useful
    echo "$flags" | grep -qw "rdrand"  && supported+=("RDRAND")
    echo "$flags" | grep -qw "pdpe1gb" && supported+=("1G-Pages")

    if [ ${#supported[@]} -gt 0 ]; then
        local joined
        joined=$(IFS=","; echo "${supported[*]}")
        echo "󰻠  CPU Flags:${joined}"
    fi
}

# Execute if run directly
module_cpu_flags
