# Exit on error
$ErrorActionPreference = "Stop"

Write-Host "Starting ClearML Server Deployment for Windows..." -ForegroundColor Green

# Variables
$ClearMLDir = "$PWD\clearml"
$DockerComposeFileUrl = "https://raw.githubusercontent.com/allegroai/clearml-server/master/docker/docker-compose.yml"

# Reminder for memory allocation in Docker Desktop
Write-Host "Reminder: Ensure memory allocation in Docker Desktop is at least 8GB."
Read-Host "Press Enter to continue after verifying memory allocation"

# Create ClearML directories
Write-Host "Creating directories for ClearML Server in $ClearMLDir..."
New-Item -ItemType Directory -Force -Path "$ClearMLDir\data\elastic_7"
New-Item -ItemType Directory -Force -Path "$ClearMLDir\data\mongo_4\db"
New-Item -ItemType Directory -Force -Path "$ClearMLDir\data\mongo_4\configdb"
New-Item -ItemType Directory -Force -Path "$ClearMLDir\data\redis"
New-Item -ItemType Directory -Force -Path "$ClearMLDir\data\fileserver"
New-Item -ItemType Directory -Force -Path "$ClearMLDir\logs"
New-Item -ItemType Directory -Force -Path "$ClearMLDir\config"

# Download docker-compose.yml
Write-Host "Downloading ClearML Server docker-compose file..."
Invoke-WebRequest -Uri $DockerComposeFileUrl -OutFile "$ClearMLDir\docker-compose.yml"

# Run ClearML Server
Write-Host "Launching ClearML Server..."
docker-compose -f "$ClearMLDir\docker-compose.yml" up -d

Write-Host "ClearML Server is now running on http://localhost:8080" -ForegroundColor Green