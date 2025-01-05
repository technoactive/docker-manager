#!/bin/bash

setup_logging() {
    local log_dir="/var/log/docker-manager"
    mkdir -p "$log_dir"
    LOG_FILE="$log_dir/docker-manager-$(date +%Y%m%d_%H%M%S).log"
    exec 1> >(tee -a "$LOG_FILE")
    exec 2> >(tee -a "$LOG_FILE" >&2)
    
    print_info "Logging started at $LOG_FILE"
}

print_header() {
    clear
    echo -e "${GREEN}=============================================${NC}"
    echo -e "${GREEN}   Docker Installation and Management Tool    ${NC}"
    echo -e "${GREEN}=============================================${NC}"
    echo
}

print_info() {
    echo -e "${BLUE}INFO: $1${NC}" | tee -a "$LOG_FILE"
}

print_warning() {
    echo -e "${YELLOW}WARNING: $1${NC}" | tee -a "$LOG_FILE"
}

print_error() {
    echo -e "${RED}ERROR: $1${NC}" | tee -a "$LOG_FILE"
}

print_success() {
    echo -e "${GREEN}SUCCESS: $1${NC}" | tee -a "$LOG_FILE"
}
