#!/bin/bash

###  The purpose of this script is to install and set up a git SSH Key and repository on an Ubuntu Machine.


# - - - Error Handling Fucntion - - - #

check_command(){
	if [ $? -ne 0 ]; then
		echo "ERROR: $1 failed.  Exiting."
		exit 1
	fi
}


echo "Beginning Git Installation..."

# 1.  Update System and install Git if not already installed:
echo "Updating package lists..."
sudo apt update
check_command "apt update"

echo "Installing Git..."
sudo apt install git -y
check_command "Git installation"

# 2.  Configure your Git username:
read -p "Enter your Github User Name:  " git_username
git config --global user.name "$git_username"
echo "Git User Name set to:  $(git config --global user.name)"
check_command "Set Username"

# 3.  Configure your Git email address:
read -p "Enter the email address you're using for Github:  " git_email
git config --global user.email "$git_email"
echo "Git e-mail set to: $(git config --global user.email)"
check_command "Set e-mail"

# 4.  Generate a new SSH Key Pair:
echo "Setting a new SSH Key.  You can press 'Enter' to accept defaults..."
ssh-keygen -t ed25519 -C "$git_email"
check_command "SSH key generation"

# 5.  Display SSH Key for Github authorization:
echo "Please copy the key below, and use it to pair in Github's Interface..."
cat ~/.ssh/id_ed25519.pub
read -p "Press Enter to continue..."

# 6.  Start the SSH Agent:
echo "Starting SSH Agent..."
eval "$(ssh-agent -s)"
check_command "Start SSH agent"

# 7.  Add Private Key to SSH Agent:
echo "Adding Private Key to SSH Agent..."
ssh-add ~/.ssh/id_ed25519
check_command "Adding private key to SSH agent"

# 8.  Test Connection to github:
echo "Checking Connection to Github..."
ssh -T git@github.com
check_command "Test Connection"

# 9.  Clone Repository
read -p "Please add the full URL to the Repository you would like to clone:  " git_repo
git clone "$git_repo"
check_command "Clone Repository"
echo "Repository '$git_repo' cloned successfully."
