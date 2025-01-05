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
            PORTAINER_VERSION=$(docker inspect portainer | grep -m 1 '"Image":' | awk -F':' '{print $3}' | tr -d '"},' | tr -d " ")
            if [ -n "$PORTAINER_VERSION" ]; then
                print_info "Portainer is installed (Version: $PORTAINER_VERSION)"
            else
                print_info "Portainer is installed (Version: Unable to determine)"
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
