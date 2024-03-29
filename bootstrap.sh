#!/bin/bash

# Description: Bootstrap script for setting up a new server

# Discard stdin
read -N 999999 -t 0.001

set -e

echo "This script will configure a linux machine"

echo "Do you want to upgrade? (y/n)"
read upgrade
if [ $upgrade = "y" ]; then
    # update packages
    echo "Upgrading system"
    sudo apt update
    sudo apt upgrade -y
    sudo apt install -y git python3-pip python3-venv pipx ansible
else
    echo "Not upgrading packages"
fi


# check if ansible dir exists if it does delete it
if [ -d "ansible" ]; then
    echo "Ansible dir exists"
    echo "Deleting ansible dir"
    rm -rf ansible
fi

# clone github repo
echo "Cloning github repo"
git clone https://github.com/elotojaa/ansible

echo "Checking if secret.yml and options.yml files exist"

# Check if secret.yml and options.yml files exist
if [ ! -f "secret.yml" ] && [ ! -f "options.yml" ]; then
    echo "secret.yml and options.yml files not found"
    echo "Copying example files"
    cp ansible/secret.example.yml secret.yml
    cp ansible/options.example.yml options.yml
    exit 1
fi

# Check if secret.yml file exists
if [ ! -f "secret.yml" ]; then
    echo "secret.yml file not found"
    cp ansible/secret.example.yml secret.yml
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
    cp ansible/options.example.yml options.yml
    exit 1
fi

# move files
echo "Moving files"
cd ansible
cp ../secret.yml .
cp ../options.yml .

# run ansible playbook
echo "Running ansible playbook"
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
    mv ../custom.yml ./config/custom.yml
    ansible-playbook run.yml --extra-vars "version=custom"
else
    echo "Invalid version"
fi

# ask to remove files
echo "Do you want to remove files? (y/n)"
read remove
if [ $remove = "y" ]; then
    echo "Removing files"
    cd ..
    rm -rf ansible
    rm secret.yml
    rm options.yml
else
    echo "Not removing files"
fi