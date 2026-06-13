#!/bin/bash

#═════════════════════════════════════════════════════════════════
# gfetch Backup Status Module (103-backup-status.sh)
# Displays: Last backup time, active status with %, age warning
#═════════════════════════════════════════════════════════════════

BACKUP_DIR="/mnt/seagate"
BACKUP_PREFIX="GlitchServer-900GB.vtoy.backup"
STATUS_FILE="/tmp/glitch-backup-status.lock"
CRITICAL_AGE_HOURS=48

#═════════════════════════════════════════════════════════════════
# Helper: Convert seconds to human-readable format
#═════════════════════════════════════════════════════════════════

format_time() {
    local seconds=$1
    
    if [[ $seconds -lt 60 ]]; then
        echo "${seconds}s"
    elif [[ $seconds -lt 3600 ]]; then
        echo "$(($seconds / 60))m"
    elif [[ $seconds -lt 86400 ]]; then
        echo "$(($seconds / 3600))h"
    else
        echo "$(($seconds / 86400))d"
    fi
}

#═════════════════════════════════════════════════════════════════
# Get Latest Backup Timestamp
#═════════════════════════════════════════════════════════════════

get_latest_backup() {
    local latest=$(find "$BACKUP_DIR" -maxdepth 1 -name "${BACKUP_PREFIX}.*" -type f 2>/dev/null | sort | tail -1)
    
    if [[ -z "$latest" ]]; then
        echo ""
        return
    fi
    
    basename "$latest" | sed "s/${BACKUP_PREFIX}\.//"
}

#═════════════════════════════════════════════════════════════════
# Parse Timestamp to Seconds Since Epoch
#═════════════════════════════════════════════════════════════════

timestamp_to_epoch() {
    local ts=$1
    # Format: YYYYMMDD-HHMMSS
    local year="${ts:0:4}"
    local month="${ts:4:2}"
    local day="${ts:6:2}"
    local hour="${ts:9:2}"
    local min="${ts:11:2}"
    local sec="${ts:13:2}"
    
    date -d "$year-$month-$day $hour:$min:$sec" +%s 2>/dev/null || echo "0"
}

#═════════════════════════════════════════════════════════════════
# Check if Backup is Currently Running
#═════════════════════════════════════════════════════════════════

get_backup_progress() {
    if [[ ! -f "$STATUS_FILE" ]]; then
        return
    fi
    
    local status=$(head -1 "$STATUS_FILE" 2>/dev/null)
    
    if [[ "$status" != "RUNNING" ]]; then
        return
    fi
    
    # Estimate progress by checking current backup file size
    local backup_file=$(find "$BACKUP_DIR" -maxdepth 1 -name "${BACKUP_PREFIX}.*" -type f -mmin -5 2>/dev/null | sort | tail -1)
    
    if [[ -z "$backup_file" ]]; then
        return
    fi
    
    local current_size=$(stat -c%s "$backup_file" 2>/dev/null)
    local source_size=$(stat -c%s /mnt/disk-dock/GlitchServer-900GB.vtoy 2>/dev/null)
    
    if [[ $source_size -gt 0 ]]; then
        local percent=$(($current_size * 100 / $source_size))
        [[ $percent -gt 100 ]] && percent=100
        echo "$percent"
    fi
}

#═════════════════════════════════════════════════════════════════
# Main Output Logic
#═════════════════════════════════════════════════════════════════

# Check if backup is running
if [[ -f "$STATUS_FILE" ]] && grep -q "^RUNNING$" "$STATUS_FILE" 2>/dev/null; then
    PROGRESS=$(get_backup_progress)
    if [[ -n "$PROGRESS" ]]; then
        echo "  Backup [${PROGRESS}%]"
    else
        echo "  Backup [initiating...]"
    fi
    exit 0
fi

# Get latest backup timestamp
LATEST_BACKUP=$(get_latest_backup)

if [[ -z "$LATEST_BACKUP" ]]; then
    # No backups exist
    echo "  Last Backup [never]"
    exit 0
fi

# Convert timestamp to hours ago
BACKUP_EPOCH=$(timestamp_to_epoch "$LATEST_BACKUP")
CURRENT_EPOCH=$(date +%s)
SECONDS_AGO=$(($CURRENT_EPOCH - $BACKUP_EPOCH))
HOURS_AGO=$(($SECONDS_AGO / 3600))

# Format display time
if [[ $HOURS_AGO -lt 1 ]]; then
    DISPLAY_TIME="$(format_time $SECONDS_AGO)"
elif [[ $HOURS_AGO -lt 24 ]]; then
    DISPLAY_TIME="${HOURS_AGO}h"
elif [[ $HOURS_AGO -lt 168 ]]; then
    DISPLAY_TIME="$(($HOURS_AGO / 24))d"
else
    DISPLAY_TIME="$(($HOURS_AGO / 24))d"
fi

# Check if backup is critically old (>48h)
if [[ $HOURS_AGO -gt $CRITICAL_AGE_HOURS ]]; then
    echo "  Backup ${HOURS_AGO}h ago"
elif [[ $HOURS_AGO -gt 36 ]]; then
    echo "  Backup ${HOURS_AGO}h ago"
else
    echo "  Backup $DISPLAY_TIME ago"
fi

exit 0

# echo " Latest Backup [hh:mm]"

# if backup is currently running show [Backup active: 45%]

# echo "  Backup Active [12%]"

#if backup has failed or is older than 48h show warning

# echo "  Backup Failed [hh:mm]"

# If system has have gone long without backup.

# echo "  Last Backup 48h+"
