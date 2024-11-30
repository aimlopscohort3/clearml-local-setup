#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function for error handling
handle_error() {
    echo "An error occurred on line $1."
    exit 1
}
trap 'handle_error $LINENO' ERR

echo "Starting ClearML Server Deployment for macOS..."

# Variables
CLEARML_DIR="$PWD/clearml"
DOCKER_COMPOSE_FILE_URL="https://raw.githubusercontent.com/allegroai/clearml-server/master/docker/docker-compose.yml"

# macOS: Reminder for memory allocation in Docker Desktop
echo "Reminder: Ensure memory allocation in Docker Desktop is at least 8GB."
read -p "Press Enter to continue after verifying memory allocation..."

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
chown -R $(whoami):staff "${CLEARML_DIR}"

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