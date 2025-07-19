# Git SSH Key & Repository Setup Script for Ubuntu
This README.md provides instructions and information for the git-ssh-setup.sh script.

# Table of Contents
About the Script

Prerequisites

How to Use

What the Script Does

Important Manual Step

Error Handling

Related Scripts

# About the Script
The git-ssh-setup.sh script automates the process of installing Git, configuring your Git user details, generating a new SSH key pair, and cloning an existing GitHub repository on an Ubuntu server. It's designed for initial setup where a machine is not yet connected to GitHub via SSH.

# Prerequisites
- An Ubuntu server or virtual machine.
- sudo privileges on the Ubuntu machine.
- An active GitHub account.
- The SSH URL of the GitHub repository you wish to clone.

How to Use
# 1. Save the script:
Save the provided script content into a file named git-ssh-setup.sh on your Ubuntu machine.

Example: Create the file and paste the content
```
nano git-ssh-setup.sh
```

# 2. Make the script executable:
Before running, you need to give the script execution permissions:

```
chmod +x git-ssh-setup.sh
```

# 3.  Run the script:
Execute the script from your terminal:

```
./git-ssh-setup.sh
```

The script will prompt you for your GitHub username, email, and the repository URL at various stages.

# What the Script Does
The script performs the following actions in order:

1.  Updates Package Lists: Runs sudo apt update to refresh your system's package information.

2.  Installs Git: Installs the Git version control system using sudo apt install git -y.

3.  Configures Git Username: Prompts you to enter your GitHub username and sets it globally for Git.

4.  Configures Git Email: Prompts you to enter your GitHub email address and sets it globally for Git.

5.  Generates SSH Key Pair: Creates a new ED25519 SSH key pair (id_ed25519 and id_ed25519.pub) in your ~/.ssh/ directory. You can press Enter to accept default file locations and no passphrase.

6.  Displays Public SSH Key: Prints your newly generated public SSH key (~/.ssh/id_ed25519.pub) to the console.

7.  Starts SSH Agent: Initializes the SSH agent to manage your SSH keys.

8.  Adds Private Key to Agent: Adds your private SSH key to the SSH agent for use in the current session.

9.  Tests GitHub Connection: Attempts to connect to git@github.com to verify your SSH setup is working correctly with GitHub.

10. Clones Repository: Prompts you for the full SSH URL of the GitHub repository you wish to clone and then clones it to your current directory.

# Important Manual Step
After step 5 (Display SSH Key for GitHub authorization), the script will pause and wait for you to press Enter.

During this pause, you must manually copy the displayed public SSH key (the output of cat ~/.ssh/id_ed25519.pub) and add it to your GitHub account settings.

Steps to add the key to GitHub:

1.  Copy the entire key string from your terminal (it starts with ssh-ed25519 and ends with your email address).

2.  Go to GitHub.com and log in.

3.  Click on your profile picture in the top right corner, then select Settings.

4.  In the left sidebar, click on SSH and GPG keys.

5.  Click the New SSH key or Add SSH key button.

6.  Give your key a descriptive title (e.g., "My Ubuntu Server").

7.  Paste the copied public key into the "Key" field.

8.  Click Add SSH key.

Once you've successfully added the key to GitHub, return to your terminal and press Enter to allow the script to continue.

# Error Handling
The script includes a check_command function that verifies the success of each major command. If any command fails (returns a non-zero exit code), the script will print an ERROR message indicating which step failed and then exit. This helps in debugging and ensures that the script doesn't proceed with a broken setup.
