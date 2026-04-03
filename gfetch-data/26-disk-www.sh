#!/bin/bash
module_disk() {
    local disk_info=$(df -h /var/www | awk 'NR==2 {print $3"/"$2" ("$5")"}')
    echo "󰉉 ${disk_info}"
}
module_disk
