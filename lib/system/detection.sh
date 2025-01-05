#!/bin/bash

detect_installation() {
    print_header
    echo -e "${BLUE}Checking your current installation...${NC}\n"

    # Check Docker
    if command -v docker &> /dev/null; then
        DOCKER_VERSION=$(docker --version | awk '{print $3}' | sed 's/,//')
        print_info "Docker is installed (Version: $DOCKER_VERSION)"
        DOCKER_INSTALLED=true
        
        # Determine installation type
        if systemctl is-active --quiet docker; then
            DOCKER_TYPE="root"
        else
            DOCKER_TYPE="rootless"
        fi

        # Check Docker Compose
        if docker compose version &> /dev/null; then
            COMPOSE_VERSION=$(docker compose version --short 2>/dev/null)
            print_info "Docker Compose is installed (Version: $COMPOSE_VERSION)"
            COMPOSE_INSTALLED=true
        else
            print_info "Docker Compose is not installed"
            COMPOSE_INSTALLED=false
        fi

        # Check Portainer
        if docker ps -a 2>/dev/null | grep -q portainer; then
            PORTAINER_VERSION=$(docker inspect portainer/portainer-ce 2>/dev/null | grep -m 1 '"Image": "portainer/portainer-ce:' | awk -F':' '{print $2}' | tr -d '," ')
            if [ -z "$PORTAINER_VERSION" ]; then
                PORTAINER_VERSION="version unknown"
            fi
            print_info "Portainer is installed (Version: $PORTAINER_VERSION)"
            PORTAINER_INSTALLED=true
        else
            print_info "Portainer is not installed"
            PORTAINER_INSTALLED=false
        fi
    else
        print_info "Docker is not installed"
        DOCKER_INSTALLED=false
        print_info "Docker Compose is not installed"
        COMPOSE_INSTALLED=false
        print_info "Portainer is not installed"
        PORTAINER_INSTALLED=false
    fi

    echo
    read -p "Press Enter to continue..."
}

check_versions() {
    if command -v docker &>/dev/null; then
        local current_version=$(docker --version | awk '{print $3}' | sed 's/,//')
        local latest_version=$(curl -m 10 --retry 3 -s https://api.github.com/repos/docker/docker-ce/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
        
        if [ -n "$latest_version" ] && [ "$current_version" != "$latest_version" ]; then
            print_info "A new Docker version is available: $latest_version"
            print_info "Current version: $current_version"
        fi

        if docker compose version &> /dev/null; then
            local compose_version=$(docker compose version --short 2>/dev/null)
            print_info "Docker Compose version: $compose_version"
        fi

        if docker ps -a 2>/dev/null | grep -q portainer; then
            local portainer_version=$(docker inspect portainer/portainer-ce 2>/dev/null | grep -m 1 '"Image": "portainer/portainer-ce:' | awk -F':' '{print $2}' | tr -d '," ')
            print_info "Portainer version: $portainer_version"
        fi
    fi
}
