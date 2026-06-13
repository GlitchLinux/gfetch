#!/bin/bash
# 118-cron-jobs.sh — Total crontab entries across all users

module_cron() {
    local user_count=0
    local sys_count=0
    # User crontabs
    if [ -d /var/spool/cron/crontabs ]; then
        user_count=$(cat /var/spool/cron/crontabs/* 2>/dev/null | grep -cvE '^#|^$')
    fi
    # System crontab
    if [ -f /etc/crontab ]; then
        sys_count=$(grep -cvE '^#|^$' /etc/crontab 2>/dev/null)
    fi
    local total=$((user_count + sys_count))
    echo "󰃰  CronJobs:${total}"
}

module_cron
