#!/bin/bash
# 150-git-repos.sh — Number of git repos under /home and /var/www

module_git_repos() {
    local count=$(find /home /var/www -maxdepth 4 -name '.git' -type d 2>/dev/null | wc -l)
    echo "󰊢  GitRepos:${count}"
}

module_git_repos
