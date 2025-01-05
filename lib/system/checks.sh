#!/bin/bash

check_root() {
    if [ "$EUID" -ne 0 ]; then
        print_error "Please run this script with sudo or as root"
        exit 1
    fi
}

check_system() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
        VERSION=$VERSION_ID
        if [[ "$OS" != "ubuntu" && "$OS" != "debian" ]]; then
            print_error "This script is only for Ubuntu/Debian based systems"
            exit 1
        fi
    else
        print_error "Cannot detect operating system"
        exit 1
    fi
}

check_dependencies() {
    local deps=("curl" "wget" "netcat" "jq" "ufw")
    local missing_deps=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            missing_deps+=("$dep")
        fi
    done
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_info "Installing required dependencies: ${missing_deps[*]}"
        apt-get update
        apt-get install -y "${missing_deps[@]}"
    fi
}
