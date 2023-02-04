# debian-ansible

A simple interactive script/Ansible playbook that sets up Debian-based machines with a few useful tools and security features.

## Usage

```
wget https://raw.githubusercontent.com/EloToJaa/ansible/master/bootstrap.sh -O bootstrap.sh && bash bootstrap.sh
```

## Features
* Automated and unattended upgrades
* SSH hardening
* SSH public key pair generation (optional, you can also use your own keys)

## FAQ
### Q: I can't copy the SSH key to my Windows machine

On Windows, you might need to create the `C:\Users\<username>\.ssh` folder manually before running the commands at the end of the playbook:
```
mkdir C:\Users\<username>\.ssh
scp -P 22 root@<server-ip-address>:/tmp/id_ssh_ed25519 C:\Users\<username>\.ssh
ssh -p 22 <username>@<server-ip-address> -i C:\Users\<username>\.ssh\id_ssh_ed25519
```
