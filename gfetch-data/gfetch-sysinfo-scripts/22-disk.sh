#!/bin/bash
# 22-disk.sh

module_disk() {
    if mountpoint -q /mnt/seagate; then
        local disk_info1=$(df -h /mnt/seagate | awk 'NR==2 {print $3"/"$2" "$5}')
        echo "  ${disk_info1}"
    fi
    if mountpoint -q /mnt/lacie; then
        local disk_info2=$(df -h /mnt/lacie | awk 'NR==2 {print $3"/"$2" "$5}')
        echo "  ${disk_info2}"
    fi
    local disk_info3=$(df -h / | awk 'NR==2 {print $3"/"$2" "$5}')
    echo "󰉉  ${disk_info3}"
}

# Execute if run directly
module_disk

# 
# 
