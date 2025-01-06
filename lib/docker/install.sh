#!/bin/bash

install_docker_root() {
    print_header
    echo "Installing Docker (Root Installation)"
    echo "This will install Docker with root privileges."
    echo "This is the traditional way to install Docker."
    echo
    
    # Check system resources
    if ! check_system_resources; then
        read -p "Press Enter to continue..."
        return
    fi
    
    # Backup existing configuration
    if [ "$DOCKER_INSTALLED" = true ]; then
        echo -e "${YELLOW}Docker is already installed. Would you like to remove it and perform a fresh installation?${NC}"
        read -p "Continue? (y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return
        fi
        backup_docker_config
        remove_docker
    fi

    # Install Docker
    print_info "Installing prerequisites..."
    apt-get update
    apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    # Add Docker GPG key
    print_info "Adding Docker GPG key..."
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/$OS/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    # Add repository
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$OS \
        $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker Engine
    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

    # Start and enable Docker service
    systemctl start docker
    systemctl enable docker

    create_recovery_script
    print_success "Docker installed successfully!"

    # Show installed versions
    docker_version=$(docker --version | awk '{print $3}' | sed 's/,//')
    compose_version=$(docker compose version --short 2>/dev/null)
    
    print_info "Docker Engine Version: $docker_version"
    print_info "Docker Compose Version: $compose_version"
    
    # Check for latest versions
    check_latest_versions

    read -p "Press Enter to continue..."
}

check_latest_versions() {
    local latest_docker_version=$(curl -m 10 --retry 3 -s https://api.github.com/repos/docker/docker-ce/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
    local current_docker_version=$(docker --version | awk '{print $3}' | sed 's/,//')
    
    if [ -n "$latest_docker_version" ] && [ "$current_docker_version" != "$latest_docker_version" ]; then
        print_info "A new Docker version is available: $latest_docker_version (Current: $current_docker_version)"
    fi
    
    if command -v docker-compose &>/dev/null || (command -v docker &>/dev/null && docker compose version &>/dev/null); then
        local compose_version=$(docker compose version --short 2>/dev/null)
        print_info "Docker Compose version: $compose_version"
    fi
}

install_docker_rootless() {
    print_header
    echo "Installing Docker (Rootless Installation)"
    echo "This will install Docker without root privileges."
    
    if [ -z "$SUDO_USER" ] || [ "$SUDO_USER" = "root" ]; then
        print_error "Rootless installation must be run with sudo from a regular user"
        read -p "Press Enter to continue..."
        return
    fi

    # Installation steps for rootless Docker
    apt-get update
    apt-get install -y uidmap dbus-user-session fuse-overlayfs slirp4netns

    print_info "Configuring systemd..."
    loginctl enable-linger $SUDO_USER

    DOCKER_USER=$SUDO_USER
    USER_HOME=$(getent passwd $DOCKER_USER | cut -d: -f6)

    su - $DOCKER_USER -c "curl -fsSL https://get.docker.com/rootless | sh"

    print_success "Rootless Docker installed successfully!"
    
    # Show installed versions
    docker_version=$(docker --version | awk '{print $3}' | sed 's/,//')
    compose_version=$(docker compose version --short 2>/dev/null)
    
    print_info "Docker Engine Version: $docker_version"
    print_info "Docker Compose Version: $compose_version"
    
    # Check for latest versions
    check_latest_versions

    read -p "Press Enter to continue..."
}
