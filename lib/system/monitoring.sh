#!/bin/bash

monitor_system() {
    print_header
    echo "System Monitoring"
    echo "================="
    
    # Monitor system resources
    monitor_resources
    
    # Monitor Docker status
    monitor_docker_status
    
    # Monitor container health
    monitor_containers
}

monitor_resources() {
    echo -e "\n${BLUE}System Resources:${NC}"
    echo "CPU Usage: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}')%"
    echo "Memory Usage: $(free -m | awk '/^Mem:/ {print $3}')MB / $(free -m | awk '/^Mem:/ {print $2}')MB"
    echo "Disk Usage: $(df -h / | awk 'NR==2 {print $5}')"
}

monitor_docker_status() {
    echo -e "\n${BLUE}Docker Status:${NC}"
    if command -v docker &>/dev/null; then
        systemctl status docker | grep "Active:"
        docker info | grep -E "Containers:|Images:|Storage Driver:|Logging Driver:|Cgroup Driver:"
    else
        echo "Docker is not installed"
    fi
}

monitor_containers() {
    echo -e "\n${BLUE}Container Status:${NC}"
    if command -v docker &>/dev/null; then
        docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    else
        echo "No containers running"
    fi
}
