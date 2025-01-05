#!/bin/bash

install_portainer() {
    print_header
    echo "Installing Portainer"
    
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        return
    fi

    # Port configuration
    while true; do
        read -p "Enter the port for Portainer web interface (default: 9443): " port
        port=${port:-9443}
        if ! [[ "$port" =~ ^[0-9]+$ ]] || ! validate_port "$port"; then
            print_error "Invalid or in-use port. Please choose another."
            continue
        fi
        break
    done

    print_info "Creating Portainer volume..."
    docker volume create portainer_data

    print_info "Installing Portainer..."
    docker run -d \
        --name portainer \
        --restart=always \
        -p $port:9443 \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v portainer_data:/data \
        portainer/portainer-ce:latest

    if [ $? -eq 0 ]; then
        local server_ip=$(get_server_ip)
        print_success "Portainer installed successfully!"
        echo -e "${GREEN}Access Portainer at:${NC}"
        echo "? Local: https://localhost:$port"
        echo "? Remote: https://$server_ip:$port"
    fi
}

update_portainer() {
    print_header
    echo "Updating Portainer"

    backup_docker_config
    docker stop portainer
    docker rm portainer
    docker pull portainer/portainer-ce:latest

    install_portainer
}
