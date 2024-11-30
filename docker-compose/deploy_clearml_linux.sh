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

echo "Starting ClearML Server Deployment for Linux..."

# Variables
CLEARML_DIR="$PWD/clearml"
DOCKER_COMPOSE_FILE_URL="https://raw.githubusercontent.com/allegroai/clearml-server/master/docker/docker-compose.yml"

# Increase Elasticsearch vm.max_map_count
echo "Configuring Elasticsearch settings..."
echo "vm.max_map_count=262144" > /tmp/99-clearml.conf
sudo mv /tmp/99-clearml.conf /etc/sysctl.d/99-clearml.conf
sudo sysctl -w vm.max_map_count=262144

# Restart Docker to apply changes
sudo service docker restart

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
sudo chown -R 1000:1000 "${CLEARML_DIR}"

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