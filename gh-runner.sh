#!/bin/bash

# Script to set up an environment with Nginx, Docker, and GitHub Actions Runner

# Function to display help
usage() {
    echo "Usage: $0 --username USERNAME --password PASSWORD --repo-url REPO_URL --folder-name FOLDER_NAME --github-pat GITHUB_PAT --repo-owner REPO_OWNER --repo-name REPO_NAME"
    echo
    echo "Arguments:"
    echo "  --username      GitHub username"
    echo "  --password      User password"
    echo "  --repo-url      GitHub repository URL"
    echo "  --folder-name   Name of the folder for the project"
    echo "  --github-pat    GitHub Personal Access Token"
    echo "  --repo-owner    Owner of the GitHub repository"
    echo "  --repo-name     Name of the GitHub repository"
    exit 1
}

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --username) USERNAME="$2"; shift ;;
        --password) PASSWORD="$2"; shift ;;
        --repo-url) REPO_URL="$2"; shift ;;
        --folder-name) FOLDER_NAME="$2"; shift ;;
        --github-pat) GITHUB_PAT="$2"; shift ;;
        --repo-owner) REPO_OWNER="$2"; shift ;;
        --repo-name) REPO_NAME="$2"; shift ;;
        --help) usage ;;
        *) echo "Unknown parameter passed: $1"; usage ;;
    esac
    shift
done

# Validate required arguments
if [ -z "$USERNAME" ] || [ -z "$PASSWORD" ] || [ -z "$REPO_URL" ] || [ -z "$FOLDER_NAME" ] || [ -z "$GITHUB_PAT" ] || [ -z "$REPO_OWNER" ] || [ -z "$REPO_NAME" ]; then
    echo "Error: Missing one or more required arguments."
    usage
fi


# GitHub API endpoint for runner registration token
API_URL="https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/actions/runners/registration-token"

# Make the API request and extract the runner token
GENERATE_RUNNER_TOKEN=$(curl -s -X POST -H "Authorization: token $GITHUB_PAT" $API_URL)

RUNNER_TOKEN=$(echo "$RUNNER_TOKEN" | grep -o '"token": "[^"]*' | cut -d'"' -f4)

# Install Nginx
sudo apt update
sudo apt install -y nginx
sudo ufw allow 'Nginx HTTP'
sudo systemctl enable nginx
sudo systemctl start nginx

# Create a Non-Root User
adduser "$USERNAME" --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "$USERNAME:$PASSWORD" | sudo chpasswd
sudo usermod -aG sudo "$USERNAME"

# Set Permissions and Create Project Directory
mkdir -p /var/www/"$FOLDER_NAME"
sudo chmod -R 777 /var/www/"$FOLDER_NAME"

# Setup GitHub Runner
cd /var/www/"$FOLDER_NAME"
sudo curl -o actions-runner-linux-x64-2.311.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-linux-x64-2.311.0.tar.gz
sudo tar xzf ./actions-runner-linux-x64-2.311.0.tar.gz


# Assuming the current user is the correct user to configure the runner
echo '$PASSWORD' | sudo -S -u $USERNAME ./config.sh --url "$REPO_URL" --token "$RUNNER_TOKEN" --unattended
sudo ./svc.sh install
sudo ./svc.sh start

# Configure Sudoers for User
echo "$USERNAME ALL=(ALL) NOPASSWD: /usr/sbin/service nginx start, /usr/sbin/service nginx stop, /usr/sbin/service nginx restart" | sudo tee /etc/sudoers.d/"$USERNAME"

# Install Docker & Docker-Compose
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo systemctl enable docker
sudo systemctl start docker

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

# Add Created User to Docker Group
sudo usermod -aG docker "$USERNAME"