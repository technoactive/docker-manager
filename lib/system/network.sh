#!/bin/bash

validate_port() {
    local port=$1
    
    # Check if port is a number
    if ! [[ "$port" =~ ^[0-9]+$ ]]; then
        return 1
    fi
    
    # Check if port is in valid range
    if [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
        return 1
    fi
    
    # Check if port is already in use
    if netstat -tuln | grep -q ":$port "; then
        return 1
    fi
    
    return 0
}

get_server_ip() {
    # First try to get IP from iproute2
    local ip=$(ip -4 addr show scope global | grep -oP "(?<=inet\s)\d+(\.\d+){3}" | head -n1)
    
    # If not found, try hostname
    if [ -z "$ip" ]; then
        ip=$(hostname -I | awk "{print \$1}")
    fi
    
    echo "$ip"
}

validate_network_connectivity() {
    local test_urls=("https://download.docker.com" "https://hub.docker.com" "https://registry.hub.docker.com")
    
    for url in "${test_urls[@]}"; do
        if ! curl --connect-timeout 5 -s -o /dev/null "$url"; then
            print_error "Cannot connect to $url. Please check your internet connection."
            return 1
        fi
    done
    return 0
}
