#!/bin/bash
# 22-disk.sh

module_disk() {
    #local disk_info=$(df -h /var/www/ | awk 'NR==2 {print $3"/"$2" "$5""}')
    #echo "󰉉  ${disk_info}"
    local disk_info2=$(df -h / | awk 'NR==2 {print $3"/"$2" "$5""}')
    echo "󰉉  ${disk_info2}"

}

# Execute if run directly
module_disk

