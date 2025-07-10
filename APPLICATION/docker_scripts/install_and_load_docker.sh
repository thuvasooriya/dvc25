#!/bin/bash

# Variables
IMAGE_NAME="dvcon_2:latest"                 # Replace with your image name and tag
TAR_FILE_PATH="./docker_scripts/docker.tar" # Replace with the path to your tar file

# Function to install Docker on Debian-based systems
install_docker_debian() {
    echo "Installing Docker on Debian-based system..."
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    sudo systemctl start docker
    sudo systemctl enable docker
    echo "Docker installation completed."
}

# Function to install Docker on Red Hat-based systems
install_docker_redhat() {
    echo "Installing Docker on Red Hat-based system..."
    sudo yum install -y yum-utils device-mapper-persistent-data lvm2
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    sudo yum install -y docker-ce docker-ce-cli containerd.io
    sudo systemctl start docker
    sudo systemctl enable docker
    echo "Docker installation completed."
}

# Function to check if Docker is installed
check_docker_installed() {
    if ! command -v docker &>/dev/null; then
        echo "Docker is not installed. Installing Docker..."
        if [ -f /etc/debian_version ]; then
            install_docker_debian
        elif [ -f /etc/redhat-release ]; then
            install_docker_redhat
        else
            echo "Unsupported system. Please install Docker manually."
            exit 1
        fi
    else
        echo "Docker is already installed."
    fi
}

# Function to load the Docker image from a tar file if it doesn't exist
load_docker_image() {
    if [[ "$(docker images -q $IMAGE_NAME 2>/dev/null)" == "" ]]; then
        echo "Docker image '$IMAGE_NAME' not found. Loading from tar file..."

        # Check if the tar file exists
        if [ -f "$TAR_FILE_PATH" ]; then
            docker load -i "$TAR_FILE_PATH"
            echo "Docker image loaded successfully."
        else
            echo "Error: Tar file '$TAR_FILE_PATH' not found."
            exit 1
        fi
    else
        echo "Docker image '$IMAGE_NAME' already exists."
    fi
}

# Main script execution
check_docker_installed
load_docker_image
