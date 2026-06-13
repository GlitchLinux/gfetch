#!/bin/bash
#═══════════════════════════════════════════════════════════════
# ssh-permaban.sh — Permanent iptables ban for SSH brute-forcers
# Threshold: >5 failed password attempts = permaban
# Whitelist: Never bans your own IPs
# Log: /etc/ssh/permabanned.list
#═══════════════════════════════════════════════════════════════

BANLIST="/etc/ssh/permabanned.list"
THRESHOLD=5
CHAIN="SSH-PERMABAN"
DRYRUN=0

# ── WHITELIST (NEVER BAN THESE) ──────────────────────────────
WHITELIST=(
    "192.168.0.0/24"
    "85.226.224.27"
    "164.68.108.224"
    "127.0.0.1"
)

# ── Parse flags ──────────────────────────────────────────────
while [[ "$1" ]]; do
    case "$1" in
        --dry-run) DRYRUN=1 ;;
        --threshold) shift; THRESHOLD="$1" ;;
        --status) 
            total=$(wc -l < "$BANLIST" 2>/dev/null || echo 0)
            echo "Permabanned IPs: $total"
            [ -f "$BANLIST" ] && tail -5 "$BANLIST"
            exit 0 ;;
        --help)
            echo "Usage: ssh-permaban.sh [--dry-run] [--threshold N] [--status]"
            exit 0 ;;
    esac
    shift
done

# ── Whitelist check function ─────────────────────────────────
is_whitelisted() {
    local ip="$1"
    for wl in "${WHITELIST[@]}"; do
        if [[ "$wl" == */* ]]; then
            # CIDR check using ipcalc or python
            if command -v python3 &>/dev/null; then
                python3 -c "
import ipaddress
try:
    net = ipaddress.ip_network('$wl', strict=False)
    addr = ipaddress.ip_address('$ip')
    exit(0 if addr in net else 1)
except:
    exit(1)
" && return 0
            fi
        elif [[ "$ip" == "$wl" ]]; then
            return 0
        fi
    done
    return 1
}

# ── Ensure custom iptables chain exists ──────────────────────
setup_chain() {
    if ! iptables -L "$CHAIN" -n &>/dev/null; then
        iptables -N "$CHAIN"
        iptables -I INPUT -p tcp --dport 22 -j "$CHAIN"
        iptables -I INPUT -p tcp --dport 2222 -j "$CHAIN"
        echo "[+] Created iptables chain: $CHAIN"
    fi
}

# ── Touch banlist ────────────────────────────────────────────
[ ! -f "$BANLIST" ] && touch "$BANLIST"

# ── Get offending IPs from journald ──────────────────────────
declare -A OFFENDERS
while read -r count ip; do
    [ -n "$ip" ] && OFFENDERS["$ip"]="$count"
done < <(journalctl -u ssh -u sshd --since "7 days ago" -q --no-pager 2>/dev/null \
    | grep "Failed password" \
    | awk '{for(i=1;i<=NF;i++) if($i=="from") print $(i+1)}' \
    | sort | uniq -c | sort -rn)

# ── Process offenders ────────────────────────────────────────
NEW_BANS=0
SKIPPED=0
ALREADY=0

[ "$DRYRUN" -eq 0 ] && setup_chain

for ip in "${!OFFENDERS[@]}"; do
    count="${OFFENDERS[$ip]}"

    # Skip if below threshold
    [ "$count" -lt "$THRESHOLD" ] && continue

    # Skip if whitelisted
    if is_whitelisted "$ip"; then
        ((SKIPPED++))
        [ "$DRYRUN" -eq 1 ] && echo "[SKIP-WHITELIST] $ip ($count attempts)"
        continue
    fi

    # Skip if already banned
    if grep -q "^$ip " "$BANLIST" 2>/dev/null; then
        ((ALREADY++))
        continue
    fi

    # Ban the IP
    if [ "$DRYRUN" -eq 1 ]; then
        echo "[WOULD BAN] $ip ($count failed attempts)"
    else
        iptables -A "$CHAIN" -s "$ip" -j DROP
        echo "$ip $(date '+%Y-%m-%d %H:%M') attempts:$count" >> "$BANLIST"
        #echo "[BANNED] $ip ($count attempts)"
    fi
    ((NEW_BANS++))
done

# ── Summary ──────────────────────────────────────────────────
TOTAL=$(wc -l < "$BANLIST" 2>/dev/null || echo 0)
#echo"════════════════════════════"
echo "  Banned IP $TOTAL"
#echo"════════════════════════════"
