#!/bin/bash

check_system_resources() {
    local min_ram_mb=$DEFAULT_MIN_RAM_MB
    local min_disk_mb=$DEFAULT_MIN_DISK_MB
    
    # Check RAM
    local total_ram=$(free -m | awk '/^Mem:/{print $2}')
    if [ "$total_ram" -lt "$min_ram_mb" ]; then
        print_error "Insufficient RAM. Minimum required: ${min_ram_mb}MB"
        return 1
    fi
    
    # Check Disk Space
    local free_disk=$(df -m / | awk 'NR==2 {print $4}')
    if [ "$free_disk" -lt "$min_disk_mb" ]; then
        print_error "Insufficient disk space. Minimum required: ${min_disk_mb}MB"
        return 1
    fi
    
    return 0
}

monitor_resources() {
    echo -e "\n${BLUE}System Resources:${NC}"
    echo "CPU Usage: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}')%"
    echo "Memory Usage: $(free -m | awk '/^Mem:/ {print $3}')MB / $(free -m | awk '/^Mem:/ {print $2}')MB"
    echo "Disk Usage: $(df -h / | awk 'NR==2 {print $5}')"
}
