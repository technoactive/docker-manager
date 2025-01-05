#!/bin/bash

remove_docker() {
    # Backup before removal
    backup_docker_config

    print_info "Removing Docker..."

    # Stop all running containers
    if command -v docker &> /dev/null; then
        print_info "Stopping all Docker containers..."
        docker stop $(docker ps -aq) 2>/dev/null || true
        docker rm -f $(docker ps -aq) 2>/dev/null || true
        docker rmi -f $(docker images -aq) 2>/dev/null || true
        docker volume rm $(docker volume ls -q) 2>/dev/null || true
        docker network rm $(docker network ls -q) 2>/dev/null || true
    fi

    # Remove packages
    print_info "Removing Docker packages..."
    apt-get remove -y docker docker-engine docker.io containerd runc
    apt-get remove -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    apt-get purge -y docker docker-engine docker.io containerd runc
    apt-get purge -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    apt-get autoremove -y

    # Remove data and configurations
    print_info "Removing Docker data and configurations..."
    rm -rf /var/lib/docker
    rm -rf /var/lib/containerd
    rm -rf /etc/docker
    rm -rf /etc/containerd
    rm -rf ~/.docker
    rm -f /etc/apt/keyrings/docker.gpg
    rm -f /etc/apt/sources.list.d/docker.list
    rm -f /usr/local/bin/docker-compose
    rm -rf ~/.docker/cli-plugins/docker-compose

    # Remove docker group
    if getent group docker >/dev/null; then
        print_info "Removing docker group..."
        groupdel docker
    fi

    print_success "Docker has been completely removed!"
}

remove_portainer() {
    print_header
    echo "Removing Portainer"
    echo "This will remove the Portainer container and its data volume"
    echo
    
    if ! docker ps -a | grep -q portainer; then
        print_error "Portainer is not installed."
        read -p "Press Enter to continue..."
        return
    fi

    read -p "Are you sure you want to remove Portainer and its data? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        return
    fi

    # Backup before removal
    backup_docker_config

    print_info "Stopping Portainer container..."
    docker stop portainer

    print_info "Removing Portainer container..."
    docker rm portainer

    print_info "Removing Portainer volume..."
    docker volume rm portainer_data

    # Remove firewall rule if exists
    if ufw status | grep -q "9443/tcp"; then
        print_info "Removing Portainer firewall rule..."
        ufw delete allow 9443/tcp
    fi

    print_success "Portainer has been removed successfully!"
    read -p "Press Enter to continue..."
}

remove_everything() {
    print_header
    echo "This will completely remove Docker, Docker Compose, and Portainer"
    echo "Warning: This will remove all containers, images, and volumes!"
    echo
    read -p "Are you sure you want to continue? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        return
    fi

    # Create final backup
    backup_docker_config

    # First remove Portainer if installed
    if docker ps -a | grep -q portainer; then
        print_info "Removing Portainer..."
        remove_portainer
    fi

    # Then remove Docker and everything else
    remove_docker

    # Remove recovery script
    if [ -f "/usr/local/bin/docker-recovery" ]; then
        rm -f /usr/local/bin/docker-recovery
    fi

    print_success "Docker, Docker Compose, and Portainer have been completely removed!"
    read -p "Press Enter to continue..."
}
