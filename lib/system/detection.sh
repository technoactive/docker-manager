#!/bin/bash

check_portainer_updates() {
    # Get the latest version from Portainer API
    local latest_version=$(curl -s https://api.github.com/repos/portainer/portainer/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
    if [ -n "$latest_version" ]; then
        print_info "Latest available Portainer version: $latest_version"
        print_info "To update, use the Update Portainer option from the menu"
    fi
}

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
            # Get Portainer container status
            CONTAINER_STATUS=$(docker inspect -f '{{.State.Status}}' portainer 2>/dev/null)
            PORTAINER_TAG=$(docker inspect -f '{{.Config.Image}}' portainer 2>/dev/null | awk -F':' '{print $2}')
            
            if [ "$CONTAINER_STATUS" = "running" ]; then
                STATUS_MSG="running"
            else
                STATUS_MSG="stopped"
            fi

            if [ "$PORTAINER_TAG" = "latest" ] || [ -z "$PORTAINER_TAG" ]; then
                print_info "Portainer CE is installed ($STATUS_MSG)"
                # Check for updates
                check_portainer_updates
            else
                print_info "Portainer CE is installed (Version: $PORTAINER_TAG, $STATUS_MSG)"
                check_portainer_updates
            fi
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
