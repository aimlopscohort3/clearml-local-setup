Overview

This setup deploys the ClearML Server locally using Docker Compose. The ClearML Server consists of several services, including the web interface, database backends, and task scheduling agents.

Services Included:

	•	Webserver: Access the ClearML Web UI.
	•	MongoDB: Database backend for storing project/task metadata.
	•	Elasticsearch: Search engine for task and log indexing.
	•	Redis: Task queuing service.
	•	Agent Services: Backend processing for ClearML tasks.
	•	Async Delete: Handles asynchronous data cleanup.

Prerequisites

	1.	Docker Desktop:
	•	Install Docker Desktop for your platform (Linux/macOS/Windows).
	•	Allocate at least 8GB of memory in Docker → Preferences → Resources → Memory.
	•	Add the ClearML directory path to Docker’s File Sharing settings (for macOS and Windows).
	2.	ClearML Scripts:
	•	Download the appropriate deployment script for your platform:
	•	Linux: deploy_clearml_linux.sh
	•	macOS: deploy_clearml_mac.sh
	•	Windows: deploy_clearml_windows.ps1

Instructions by Platform

Linux

	1.	Make the script executable:

chmod +x deploy_clearml_linux.sh


	2.	Run the script:

./deploy_clearml_linux.sh


	3.	Follow any on-screen instructions. The script will:
	•	Configure Elasticsearch (vm.max_map_count).
	•	Create necessary directories.
	•	Download the docker-compose.yml file.
	•	Start the ClearML Server using Docker Compose.

macOS

	1.	Make the script executable:

chmod +x deploy_clearml_mac.sh


	2.	Run the script:

./deploy_clearml_mac.sh


	3.	Follow any on-screen instructions. The script will:
	•	Prompt you to verify Docker Desktop memory allocation (8GB or more).
	•	Create necessary directories.
	•	Download the docker-compose.yml file.
	•	Start the ClearML Server using Docker Compose.

Windows

	1.	Open PowerShell with administrator privileges.
	2.	Run the script:

./deploy_clearml_windows.ps1


	3.	Follow any on-screen instructions. The script will:
	•	Prompt you to verify Docker Desktop memory allocation (8GB or more).
	•	Create necessary directories.
	•	Download the docker-compose.yml file.
	•	Start the ClearML Server using Docker Compose.

Accessing the ClearML Services

	1.	Web Interface:
	•	Open a web browser and navigate to:

http://localhost:8080


	•	This is the ClearML dashboard where you can manage projects, experiments, and tasks.

	2.	ClearML SDK:
	•	Configure the ClearML Python SDK to connect to your local ClearML Server:

clearml-init


	•	Enter the following when prompted:
	•	API Server: http://localhost:8008
	•	Web Server: http://localhost:8080
	•	File Server: http://localhost:8081
	•	Add the API credentials to your clearml.conf or environment variables.

	3.	Monitoring Services:
	•	Use Docker commands to monitor running services:

docker ps


	•	Check logs for specific services:

docker-compose logs -f <service-name>

Stopping the ClearML Server

To stop the services gracefully:

docker-compose down

Troubleshooting

Common Issues

	1.	Platform Mismatch:
	•	Ensure the platform: linux/amd64 directive is added to the docker-compose.yml file for ARM-based systems (like M1/M2 MacBooks).
	2.	File Sharing Denied:
	•	Ensure the ClearML deployment directory is added to Docker Desktop’s File Sharing settings.
	3.	Service Not Starting:
	•	Check logs for specific services to diagnose issues:

docker-compose logs -f <service-name>


	4.	Low Memory:
	•	Increase memory allocation in Docker Desktop Preferences → Resources.

Additional Commands

Restart Services

docker-compose restart

Remove Containers and Volumes

docker-compose down -v

Check Resource Usage

docker stats

Documentation and Support

	•	ClearML Documentation: https://clear.ml/docs/
	•	GitHub Repository: https://github.com/allegroai/clearml-server

This README ensures users on any platform can execute the deployment scripts correctly. Let me know if further adjustments are needed!