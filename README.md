# Docker Manager

A comprehensive Bash script for managing Docker installations on Ubuntu/Debian systems. This tool provides an easy-to-use interface for installing and managing Docker, Docker Compose, and Portainer.

## Features

- **Docker Management**
  - Root installation
  - Rootless installation
  - Update management
  - Complete removal capability

- **Docker Compose Management**
  - Installation
  - Updates
  - Version management

- **Portainer Management**
  - Easy installation
  - Automatic updates
  - Configuration management

- **System Tools**
  - System requirement verification
  - Network connectivity checks
  - Automatic dependency installation
  - Backup and recovery tools

## Prerequisites

- Ubuntu or Debian based system
- Root privileges (sudo access)
- Internet connection
- Minimum system requirements:
  - RAM: 1GB
  - Disk Space: 10GB

## Installation

1. Clone the repository:
```bash
git clone https://github.com/technoactive/docker-manager.git
cd docker-manager
```

2. Make the scripts executable:
```bash
chmod +x docker-manager.sh
find . -type f -name "*.sh" -exec chmod +x {} \;
```

3. Run the script:
```bash
sudo ./docker-manager.sh
```

## Usage

The script provides an interactive menu with the following options:

### Docker Management:
1. Install Docker (Root Installation)
2. Install Docker (Rootless Installation)
3. Update Docker

### Docker Compose Management:
4. Install Docker Compose
5. Update Docker Compose

### Portainer Management:
6. Install Portainer
7. Update Portainer
8. Remove Portainer

### System Management:
9. Remove Everything
10. System Information
11. View Logs
12. Exit

## Project Structure

```
docker-manager/
├── docker-manager.sh        # Main script
├── config/
│   ├── config.sh           # Configuration variables
│   └── colors.sh           # Color definitions
├── lib/
│   ├── core/
│   │   ├── logging.sh      # Logging functions
│   │   ├── menu.sh         # Menu system
│   │   └── error_handling.sh
│   ├── system/
│   │   ├── checks.sh       # System checks
│   │   ├── resources.sh    # Resource monitoring
│   │   ├── network.sh      # Network utilities
│   │   └── detection.sh    # Installation detection
│   ├── docker/
│   │   ├── install.sh      # Docker installation
│   │   ├── compose.sh      # Docker Compose
│   │   ├── portainer.sh    # Portainer management
│   │   └── remove.sh       # Removal utilities
│   ├── backup/
│   │   ├── backup.sh       # Backup functionality
│   │   └── recovery.sh     # Recovery tools
│   └── security/
│       └── security.sh     # Security checks
└── tests/
    └── test_suite.sh       # Testing framework
```

## Features Details

### Docker Installation
- Supports both root and rootless installations
- Automatic dependency resolution
- System compatibility checks
- Configuration backup before modifications

### Docker Compose
- Latest version installation
- Automatic updates
- Version management

### Portainer
- Easy web UI installation
- Automatic container management
- Port configuration
- SSL/TLS support

### System Management
- Resource monitoring
- Network checks
- Security verifications
- Comprehensive logging

## Security

- Automatic security updates check
- UFW firewall configuration
- TLS/SSL configuration for Docker daemon
- Secure default configurations

## Backup and Recovery

- Automatic backup before major operations
- Configuration backup
- Recovery script generation
- Backup rotation

## Logging

- Comprehensive logging system
- Detailed error reporting
- Operation history
- Debug information

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Docker Documentation
- Portainer Team
- Docker Compose Documentation

## Support

For support, please open an issue in the GitHub repository.

## Disclaimer

This script makes changes to your system configuration. Always backup your data before using it in a production environment.
