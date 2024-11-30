#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function for error handling
handle_error() {
    echo "An error occurred on line $1."
    exit 1
}
trap 'handle_error $LINENO' ERR

# Check for root privileges
if [[ "$EUID" -ne 0 ]]; then
    echo "Please run this script as root (or using sudo)."
    exit 1
fi

echo "Starting ClearML Server Deployment..."

# Variables
DOCKER_COMPOSE_VERSION="1.24.1"
CLEARML_DIR="$PWD/clearml"
DOCKER_COMPOSE_URL="https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)"
DOCKER_COMPOSE_FILE_URL="https://raw.githubusercontent.com/allegroai/clearml-server/master/docker/docker-compose.yml"

# Check for Docker installation
if ! command -v docker &>/dev/null; then
    echo "Docker not found. Installing Docker..."
    if [[ "$(uname)" == "Linux" ]]; then
        apt-get update && apt-get install -y docker.io
    else
        echo "Please install Docker manually on macOS. Exiting."
        exit 1
    fi
else
    echo "Docker is already installed."
fi

# Verify Docker Installation
echo "Verifying Docker installation..."
docker run --rm hello-world || { echo "Docker verification failed. Please check your Docker installation."; exit 1; }

# Install Docker Compose (Linux only)
if [[ "$(uname)" == "Linux" && ! -f /usr/local/bin/docker-compose ]]; then
    echo "Installing Docker Compose..."
    curl -L "${DOCKER_COMPOSE_URL}" -o /usr/local/bin/docker-compose || { echo "Failed to download Docker Compose."; exit 1; }
    chmod +x /usr/local/bin/docker-compose
else
    echo "Docker Compose is already installed."
fi

# macOS: Reminder for memory allocation in Docker Desktop
if [[ "$(uname)" == "Darwin" ]]; then
    echo "Reminder: Ensure memory allocation in Docker Desktop is at least 8GB."
    read -p "Press Enter to continue after verifying memory allocation..."
fi

# Increase Elasticsearch vm.max_map_count (Linux only)
if [[ "$(uname)" == "Linux" ]]; then
    echo "Configuring Elasticsearch settings..."
    echo "vm.max_map_count=262144" > /tmp/99-clearml.conf
    mv /tmp/99-clearml.conf /etc/sysctl.d/99-clearml.conf
    sysctl -w vm.max_map_count=262144
    service docker restart
fi

# Create ClearML directories
echo "Creating directories for ClearML Server in $CLEARML_DIR..."
mkdir -p "${CLEARML_DIR}/data/elastic_7" \
         "${CLEARML_DIR}/data/mongo_4/db" \
         "${CLEARML_DIR}/data/mongo_4/configdb" \
         "${CLEARML_DIR}/data/redis" \
         "${CLEARML_DIR}/data/fileserver" \
         "${CLEARML_DIR}/logs" \
         "${CLEARML_DIR}/config"

# Adjust permissions
if [[ "$(uname)" == "Linux" ]]; then
    chown -R 1000:1000 "${CLEARML_DIR}"
elif [[ "$(uname)" == "Darwin" ]]; then
    chown -R $(whoami):staff "${CLEARML_DIR}"
fi

# Download docker-compose.yml
if curl -o "${CLEARML_DIR}/docker-compose.yml" "${DOCKER_COMPOSE_FILE_URL}"; then
    echo "Downloaded ClearML Server docker-compose file successfully."
else
    echo "Failed to download the docker-compose file. Exiting."
    exit 1
fi

# Run ClearML Server
echo "Launching ClearML Server..."
if docker-compose -f "${CLEARML_DIR}/docker-compose.yml" up -d; then
    echo "ClearML Server is now running on http://localhost:8080"
else
    echo "Failed to start ClearML Server."
    exit 1
fi

# Success message
echo "ClearML Server deployment completed successfully in $CLEARML_DIR!"