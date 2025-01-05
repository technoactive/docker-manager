#!/bin/bash

create_recovery_script() {
    print_info "Creating recovery script..."
    cat > /usr/local/bin/docker-recovery << 'EOF'
#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}Starting Docker recovery...${NC}"

# Restart Docker daemon
echo "Restarting Docker daemon..."
systemctl restart docker

# Wait for Docker to be available
timeout=30
while ! docker info >/dev/null 2>&1; do
    if [ $timeout -le 0 ]; then
        echo -e "${RED}Docker daemon failed to start${NC}"
        exit 1
    fi
    timeout=$((timeout-1))
    sleep 1
done

# Start all containers that were previously running
echo "Starting all containers..."
docker start $(docker ps -a -q)

echo -e "${GREEN}Recovery completed successfully!${NC}"
EOF
    chmod +x /usr/local/bin/docker-recovery
    print_info "Recovery script created at /usr/local/bin/docker-recovery"
}
