#!/bin/bash

run_tests() {
    test_system_checks
    test_docker_installation
    test_network
    test_security
}

test_system_checks() {
    echo "Testing system checks..."
    assert_command "check_root"
    assert_command "check_system"
    assert_command "check_dependencies"
}

test_docker_installation() {
    echo "Testing Docker installation..."
    assert_command "detect_installation"
    if [ "$DOCKER_INSTALLED" = true ]; then
        assert_command "docker --version"
    fi
}

test_network() {
    echo "Testing network functionality..."
    assert_command "validate_network_connectivity"
    assert_command "get_server_ip"
}

test_security() {
    echo "Testing security configuration..."
    assert_command "check_security"
    assert_command "ufw status"
}

assert_command() {
    if eval "$1" &>/dev/null; then
        echo " $1"
        return 0
    else
        echo " $1"
        return 1
    fi
}
