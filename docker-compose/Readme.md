# ClearML Server Deployment and Usage

## Overview

This setup deploys the ClearML Server locally using Docker Compose. The ClearML Server consists of several services, including the web interface, database backends, and task scheduling agents.

### Services Included:

- **Webserver**: Access the ClearML Web UI.
- **MongoDB**: Database backend for storing project/task metadata.
- **Elasticsearch**: Search engine for task and log indexing.
- **Redis**: Task queuing service.
- **Agent Services**: Backend processing for ClearML tasks.
- **Async Delete**: Handles asynchronous data cleanup.

---

## Prerequisites

### 1. Docker Desktop:
- Install and configure Docker Desktop for macOS.
- Allocate at least **8GB of memory** in **Docker → Preferences → Resources → Memory**.
- Add the ClearML directory path to Docker’s shared paths (**Preferences → Resources → File Sharing**).

### 2. ClearML Configuration:
- Ensure the `docker-compose.yml` file is properly updated with `platform: linux/amd64` for ARM-based systems (like M1/M2 MacBooks).

---

## Starting the ClearML Server

1. Open a terminal.
2. Navigate to the ClearML deployment directory (e.g., `/path/to/clearml`):

   cd docker-compose/clearml

3.	Launch the ClearML Server:

		docker-compose up -d

Accessing the ClearML Services

1. Web Interface:

	•	Open a web browser and navigate to:

		http://localhost:8080


	•	This is the ClearML dashboard where you can manage projects, experiments, and tasks.

2. ClearML SDK:

	•	Configure the ClearML Python SDK to connect to your local ClearML Server:

		clearml-init

Enter the following when prompted:

	API Server: http://localhost:8008
	Web Server: http://localhost:8080
	File Server: http://localhost:8081

•	Add the API credentials to your clearml.conf or environment variables.

3. Monitoring Services:

•	Use Docker commands to monitor running services:

		docker ps

•	Check logs for specific services:

		docker-compose logs -f <service-name>

Stopping the ClearML Server

To stop the services gracefully:

	docker-compose down

Troubleshooting

Common Issues

1. Platform Mismatch:

		Ensure the platform: linux/amd64 directive is added to the docker-compose.yml file for ARM-based macOS.
2.	File Sharing Denied:

		Ensure the ClearML deployment directory is added to Docker Desktop’s File Sharing settings.

3.	Service Not Starting:
	
		Check logs for specific services to diagnose issues:
		docker-compose logs -f <service-name>

4.	Low Memory:
	
		Increase memory allocation in Docker Desktop Preferences → Resources.

Additional Commands

•	Restart Services:
	
	docker-compose restart


•	Remove Containers and Volumes:
	
	docker-compose down -v


•	Check Resource Usage:

		docker stats

Documentation and Support

	ClearML Documentation:	 https://clear.ml/docs/
	GitHub Repository: 	https://github.com/allegroai/clearml-server
