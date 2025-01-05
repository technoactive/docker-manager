#!/bin/bash

# Version
VERSION="1.0.0"

# Default configurations
DEFAULT_PORTAINER_PORT=9443
DEFAULT_MIN_RAM_MB=1024
DEFAULT_MIN_DISK_MB=10240
MAX_BACKUPS=5

# Global variables
LOG_FILE=""
DOCKER_INSTALLED=false
COMPOSE_INSTALLED=false
PORTAINER_INSTALLED=false
DOCKER_TYPE=""

# Load custom config if exists
CUSTOM_CONFIG="/etc/docker-manager/config"
[ -f "$CUSTOM_CONFIG" ] && source "$CUSTOM_CONFIG"
