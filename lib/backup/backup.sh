#!/bin/bash

backup_docker_config() {
    local backup_dir="/var/backups/docker-manager/$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    if [ -d "/etc/docker" ]; then
        cp -r /etc/docker "$backup_dir/"
    fi
    if [ -f "/etc/docker-compose.yml" ]; then
        cp /etc/docker-compose.yml "$backup_dir/"
    fi
    if [ -d "$HOME/.docker" ]; then
        cp -r "$HOME/.docker" "$backup_dir/"
    fi
    
    # Rotate old backups
    cleanup_old_backups
    
    print_info "Backup created at $backup_dir"
}

cleanup_old_backups() {
    local backup_dir="/var/backups/docker-manager"
    local max_backups=$MAX_BACKUPS
    
    ls -1dt "$backup_dir"/* | tail -n +$((max_backups + 1)) | xargs -r rm -rf
}
