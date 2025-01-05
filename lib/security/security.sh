#!/bin/bash

check_security() {
    # Check system updates
    if [ -n "$(apt list --upgradable 2>/dev/null | grep security)" ]; then
        print_warning "Security updates are available."
        read -p "Update system now? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            apt-get update && apt-get upgrade -y
        fi
    fi
    
    # Check firewall
    if ! command -v ufw &>/dev/null; then
        print_info "Installing UFW firewall..."
        apt-get install -y ufw
    fi
    
    if ! ufw status | grep -q "active"; then
        print_warning "Firewall is not active."
        read -p "Enable UFW firewall? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            ufw allow ssh
            ufw allow 9443/tcp
            ufw --force enable
        fi
    fi
}

configure_tls() {
    local certs_dir="/etc/docker/certs"
    mkdir -p "$certs_dir"
    
    openssl req -x509 -newkey rsa:4096 -keyout "$certs_dir/key.pem" \
        -out "$certs_dir/cert.pem" -days 365 -nodes -subj "/CN=$(hostname)"
}
