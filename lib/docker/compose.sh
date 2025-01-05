#!/bin/bash

install_compose() {
    print_header
    echo "Installing Docker Compose"
    echo

    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        read -p "Press Enter to continue..."
        return
    fi

    print_info "Installing Docker Compose..."
    apt-get update
    apt-get install -y docker-compose-plugin

    if docker compose version &> /dev/null; then
        local compose_version=$(docker compose version --short 2>/dev/null)
        print_success "Docker Compose installed successfully! (Version: $compose_version)"
    else
        print_error "Docker Compose installation failed!"
    fi
    read -p "Press Enter to continue..."
}

update_compose() {
    print_header
    echo "Updating Docker Compose"
    
    backup_docker_config
    apt-get update
    apt-get install -y docker-compose-plugin

    local new_version=$(docker compose version --short 2>/dev/null)
    print_success "Docker Compose updated successfully to version $new_version!"
    read -p "Press Enter to continue..."
}
