#!/bin/bash

# Get the script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source all configurations
source "$SCRIPT_DIR/config/config.sh"
source "$SCRIPT_DIR/config/colors.sh"

# Source all library files
for lib in "$SCRIPT_DIR"/lib/**/*.sh; do
    source "$lib"
done

# Main script execution
main() {
    # Setup error handling
    set -e
    trap 'handle_error $? $LINENO $BASH_LINENO "$BASH_COMMAND" $(printf "::%s" ${FUNCNAME[@]:-})' ERR
    
    # Initialize
    check_root
    check_system
    setup_logging
    check_dependencies
    check_security
    check_system_resources
    detect_installation
    
    # Show main menu
    show_main_menu
}

# Start the script
main "$@"
