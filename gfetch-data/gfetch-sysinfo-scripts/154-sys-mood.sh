#!/bin/bash
# 154-sys-mood.sh - System "mood": a fun holistic health score derived from load, memory, and swap.
# Not serious metrics — just a quick vibe check for the machine.

module_sys_mood() {
    local ncpus load1 mem_pct swap_pct score mood

    ncpus=$(nproc 2>/dev/null || echo 1)
    load1=$(awk '{print $1}' /proc/loadavg)

    mem_pct=$(awk '/MemTotal/    {t=$2}
                   /MemAvailable/{a=$2}
                   END { printf "%.0f", (t-a)*100/t }' /proc/meminfo)

    swap_pct=$(awk '/SwapTotal/ {t=$2}
                    /SwapFree/  {f=$2}
                    END { if(t>0) printf "%.0f", (t-f)*100/t; else print "0" }' /proc/meminfo)

    # Score 0–100: higher = more stressed
    score=$(awk -v l="$load1" -v c="$ncpus" -v m="$mem_pct" -v s="$swap_pct" \
        'BEGIN {
            load_norm = (l / c) * 40
            if (load_norm > 40) load_norm = 40
            mem_norm  = m * 0.40
            swap_norm = s * 0.20
            printf "%.0f", load_norm + mem_norm + swap_norm
        }')

    local icon label
    if   [ "$score" -le 15 ]; then icon=""; label="Blissful"
    elif [ "$score" -le 30 ]; then icon=""; label="Relaxed"
    elif [ "$score" -le 50 ]; then icon="󰒓"; label="Working"
    elif [ "$score" -le 70 ]; then icon=""; label="Stressed"
    else                           icon=""; label="Struggling"
    fi

    echo "${icon}  Mood:${label} (load×${ncpus}:${load1} mem:${mem_pct}% swap:${swap_pct}%)"
}

# Execute if run directly
module_sys_mood
