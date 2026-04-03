#!/bin/bash
# 98-time_date.sh

time_date() {
    echo "  $(date +'%H:%M %-d/%-m-%y')"
}

# Execute if run directly
time_date
