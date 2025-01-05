#!/bin/bash

show_main_menu() {
    while true; do
        print_header
        echo "Please choose what you want to do:"
        echo
        echo "Docker Management:"
        echo "  1) Install Docker (Root Installation)"
        echo "  2) Install Docker (Rootless Installation)"
        echo "  3) Update Docker"
        echo
        echo "Docker Compose Management:"
        echo "  4) Install Docker Compose"
        echo "  5) Update Docker Compose"
        echo
        echo "Portainer Management:"
        echo "  6) Install Portainer"
        echo "  7) Update Portainer"
        echo "  8) Remove Portainer"
        echo
        echo "System Management:"
        echo "  9) Remove Everything (Docker, Compose, and Portainer)"
        echo " 10) System Information"
        echo " 11) View Logs"
        echo " 12) Exit"
        echo
        read -p "Enter your choice (1-12): " choice
        
        case $choice in
            1) install_docker_root ;;
            2) install_docker_rootless ;;
            3) update_docker ;;
            4) install_compose ;;
            5) update_compose ;;
            6) install_portainer ;;
            7) update_portainer ;;
            8) remove_portainer ;;
            9) remove_everything ;;
            10) show_system_info ;;
            11) view_logs ;;
            12) 
                print_info "Thank you for using Docker Manager!"
                exit 0 
                ;;
            *) 
                print_error "Invalid choice."
                read -p "Press Enter to continue..."
                ;;
        esac
    done
}
