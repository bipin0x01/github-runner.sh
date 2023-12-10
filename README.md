# Setup Script Documentation

This script automates the process of setting up an environment with Nginx, Docker, and a GitHub Actions Runner. Below are the steps and explanations for each variable used in the script.

## Prerequisites

Before running the script, ensure that you have:

- A GitHub account
- Access to a Ubuntu-based server
- Sufficient permissions to execute scripts and install packages

## Script Usage

To run the script, use the following command format:

```bash
Usage: ./gh-runner.sh --username USERNAME --password PASSWORD --repo-url REPO_URL --folder-name FOLDER_NAME --github-pat GITHUB_PAT --repo-owner REPO_OWNER --repo-name REPO_NAME
```

### Arguments

- `--username`: GitHub username
- `--password`: User password
- `--repo-url`: GitHub repository URL
- `--folder-name`: Name of the folder for the project
- `--github-pat`: GitHub Personal Access Token
- `--repo-owner`: Owner of the GitHub repository
- `--repo-name`: Name of the GitHub repository

## Variables

1. **USERNAME**

   - **Description**: The username for the new user to be created on the server.
   - **How to Create**: Choose a username that does not already exist on your system.

2. **PASSWORD**

   - **Description**: The password for the new user.
   - **How to Create**: Create a strong password.

3. **REPO_URL**

   - **Description**: The URL of your GitHub repository.
   - **How to Create**: Copy the URL from your GitHub repository. It should look like `https://github.com/[username]/[repository]`.

4. **FOLDER_NAME**

   - **Description**: The name of the folder where the project will be located.
   - **How to Create**: Choose a name for your project directory.

5. **GITHUB_PAT**

   - **Description**: GitHub Personal Access Token.
   - **How to Create**: Follow the detailed steps provided in the next section.

6. **REPO_OWNER**

   - **Description**: The owner of the GitHub repository.
   - **How to Create**: This is typically your GitHub username or the organization name that owns the repository.

7. **REPO_NAME**
   - **Description**: The name of the GitHub repository.
   - **How to Create**: This is the name of your repository on GitHub.

## Creating a GitHub Personal Access Token (PAT)

### Step 1: Accessing GitHub Settings

1. **Log in** to your GitHub account.
2. Click on your profile picture in the top-right corner of any GitHub page.
3. Select **Settings** from the dropdown menu.

### Step 2: Navigating to Developer Settings

1. In the left sidebar of the Settings page, scroll down and click on **Developer settings**.

### Step 3: Personal Access Tokens

1. Under Developer settings, select **Personal access tokens**.
2. Click on the **Generate new token** button.

### Step 4: Token Setup

1. **Note**: Enter a description for your token.
2. **Expiration**: Choose the duration for which the token is valid.
3. **Select scopes**: Scopes control the level of access your token has.

### Step 5: Generating the Token

1. After selecting the appropriate options, click the **Generate token** button.
2. Copy this token and store it securely.

### Step 6: Using the Token

1. Use this token in place of a password when authenticating to GitHub via HTTPS.

### Step 7: Security Considerations

1. Keep your token confidential and treat it like a password.

## Steps Performed by the Script

1. **Nginx Installation**: Installs the Nginx web server and configures it to start on boot.
2. **User Creation**: Creates a new user with the provided username and password.
3. **Directory Setup**: Creates a project directory and sets appropriate permissions.
4. **GitHub Actions Runner Setup**: Downloads and configures the GitHub Actions Runner for the specified repository.
5. **Docker Installation**: Installs Docker and Docker Compose on the system.
6. **User Permissions**: Adds the new user to the Docker group and configures sudoers for Nginx management.

## Post-Installation

After running the script, verify that all services are running correctly. You can check the status of Nginx and Docker with the following commands:

```bash
sudo systemctl status nginx
sudo systemctl status docker
```

Ensure that the GitHub Actions Runner appears in your repository's settings under Actions > Runners.
