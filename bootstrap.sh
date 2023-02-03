#!/bin/bash

# Description: Bootstrap script for setting up a new server

# Discard stdin
read -N 999999 -t 0.001

set -e

echo "This script will configure a linux machine"

echo "Checking if secret.yml and options.yml files exist"
# Check if secret.yml file exists
if [ ! -f "secret.yml" ]; then
    echo "secret.yml file not found"
    exit 1
fi

# Check if secret.yml file is encrypted if not encrypt it
if grep -q "$ANSIBLE_VAULT;1.1;AES256" secret.yml; then
    echo "secret.yml file is encrypted"
else
    echo "secret.yml file is not encrypted"
    echo "Encrypting secret.yml file"
    ansible-vault encrypt secret.yml
fi

# Check if options.yml file exists
if [ ! -f "options.yml" ]; then
    echo "options.yml file not found"
    exit 1
fi

echo "Updating system"
sudo apt update
sudo apt upgrade -y
sudo apt install -y git python3-pip python3-venv

# install pipx using pip
echo "Installing pipx"
pip install --user pipx
python3 -m pipx ensurepath
python3 -m pipx ensurepip

# install ansible
echo "Installing ansible"
pipx install ansible

# clone github repo
echo "Cloning github repo"
git clone https://github.com/elotojaa/ansible

# run ansible playbook
cd ansible
mv ../secret.yml .
ansible-galaxy install -r requirements.yml

# ask for version to install
echo "Which version do you want to install? (server, kali, basic, custom)"
read version
echo "Installing $version"

if [ $version = "server" ]; then
    ansible-playbook run.yml --extra-vars "version=server"
elif [ $version = "kali" ]; then
    ansible-playbook run.yml --extra-vars "version=kali"
elif [ $version = "basic" ]; then
    ansible-playbook run.yml --extra-vars "version=basic"
elif [ $version = "custom" ]; then
    echo "Checking if custom.yml file exists"
    # Check if custom.yml file exists
    if [ ! -f "custom.yml" ]; then
        echo "custom.yml file not found"
        exit 1
    fi
    mv ../custom.yml .
    ansible-playbook run.yml --extra-vars "version=custom"
else
    echo "Invalid version"
fi
