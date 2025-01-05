#!/bin/bash

show_system_info() {
    print_header
    echo "System Information:"
    echo "==================="
    
    # OS Information
    echo -e "${BLUE}Operating System:${NC}"
    lsb_release -a 2>/dev/null
    echo
    
    # System Resources
    echo -e "${BLUE}System Resources:${NC}"
    echo "CPU Cores: $(nproc)"
    echo "Memory Total: $(free -h | awk '/^Mem:/ {print $2}')"
    echo "Memory Used: $(free -h | awk '/^Mem:/ {print $3}')"
    echo "Disk Space: $(df -h / | awk 'NR==2 {print $4}') available"
    echo
    
    # Docker Information
    echo -e "${BLUE}Docker Information:${NC}"
    if command -v docker &>/dev/null; then
        docker --version
        docker compose version 2>/dev/null || echo "Docker Compose not installed"
        if docker ps -a | grep -q portainer; then
            echo "Portainer is installed"
        else
            echo "Portainer is not installed"
        fi
    else
        echo "Docker is not installed"
    fi
    echo
    
    # Network Information
    echo -e "${BLUE}Network Information:${NC}"
    ip -4 addr show scope global | grep inet
    echo
    
    # Firewall Status
    echo -e "${BLUE}Firewall Status:${NC}"
    if command -v ufw &>/dev/null; then
        ufw status
    else
        echo "UFW is not installed"
    fi
    
    read -p "Press Enter to continue..."
}

show_docker_info() {
    if command -v docker &>/dev/null; then
        echo -e "\n${BLUE}Docker Information:${NC}"
        docker info | grep -E "Server Version:|Operating System:|OSType:|Architecture:|CPUs:|Total Memory:|Docker Root Dir:|Registry:"
    fi
}

show_portainer_info() {
    if docker ps -a | grep -q portainer; then
        echo -e "\n${BLUE}Portainer Information:${NC}"
        local container_info=$(docker inspect portainer)
        echo "Status: $(docker inspect -f '{{.State.Status}}' portainer)"
        echo "Port: $(docker port portainer 9443 2>/dev/null || echo 'Not exposed')"
        echo "Version: $(docker inspect portainer/portainer-ce | grep -m 1 '"Image": "portainer/portainer-ce:' | awk -F':' '{print $2}' | tr -d '," ')"
    fi
}

show_network_info() {
    echo -e "\n${BLUE}Network Information:${NC}"
    ip -4 addr show scope global | grep inet
}

show_firewall_info() {
    echo -e "\n${BLUE}Firewall Information:${NC}"
    if command -v ufw &>/dev/null; then
        ufw status verbose
    else
        echo "UFW firewall is not installed"
    fi
}
