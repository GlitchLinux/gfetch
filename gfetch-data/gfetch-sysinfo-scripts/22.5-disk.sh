#!/bin/bash
# 22.5-disk.sh

module_disk() {
    if mountpoint -q /mnt/seagate; then
        local pct1=$(df -h /mnt/seagate | awk 'NR==2 {print $5}')
        echo "  Seagate 4TB ${pct1}"
    fi
    if mountpoint -q /mnt/lacie; then
        local pct2=$(df -h /mnt/lacie | awk 'NR==2 {print $5}')
        echo "  Lacie 2.7TB ${pct2}"
    fi
    local disk_root=$(df -h / | awk 'NR==2 {print $3"/"$2" "$5}')
    echo "󰉉  ${disk_root}"
}

# Execute if run directly
module_disk
