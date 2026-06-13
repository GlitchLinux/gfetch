#!/bin/bash
# 159-uptime-tier.sh - Uptime "achievement tier" — a fun badge for how long the system has been alive.
# Everyone loves a little gamification on their server.

module_uptime_tier() {
    local seconds tier icon days hours

    seconds=$(awk '{printf "%.0f", $1}' /proc/uptime)
    days=$(( seconds / 86400 ))
    hours=$(( (seconds % 86400) / 3600 ))

    if   [ "$seconds" -lt 300 ];    then icon=""; tier="Just Woke Up"
    elif [ "$seconds" -lt 3600 ];   then icon=""; tier="Warming Up"
    elif [ "$seconds" -lt 86400 ];  then icon=""; tier="One Full Day"
    elif [ "$days"    -lt 7 ];      then icon=""; tier="Week Warrior"
    elif [ "$days"    -lt 30 ];     then icon=""; tier="Month Grinder"
    elif [ "$days"    -lt 90 ];     then icon=""; tier="Quarter Beast"
    elif [ "$days"    -lt 365 ];    then icon=""; tier="Six-Month Slab"
    else                                 icon=""; tier="Uptime Legend"
    fi

    echo "${icon}  Uptime Tier:${tier} (${days}d ${hours}h)"
}

# Execute if run directly
module_uptime_tier
