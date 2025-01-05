#!/bin/bash

handle_error() {
    local exit_code=$1
    local line_no=$2
    local bash_lineno=$3
    local last_command=$4
    local func_trace=$5
    
    print_error "An error occurred in command '$last_command'"
    print_error "Line $line_no, Exit code: $exit_code"
    print_error "Please check the logs at $LOG_FILE"
    
    cleanup_partial_install
}

cleanup_partial_install() {
    if [ -n "$CLEANUP_NEEDED" ]; then
        print_info "Cleaning up partial installation..."
        remove_docker
    fi
}
