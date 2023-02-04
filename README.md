# kali-ansible

A simple interactive script/Ansible playbook that sets up Kali Linux

## Usage

```
wget https://raw.githubusercontent.com/EloToJaa/ansible/master/bootstrap.sh -O bootstrap.sh && bash bootstrap.sh
```

## Features
* Automated and unattended upgrades
* SSH hardening
* SSH public key pair generation (optional, you can also use your own keys)

## FAQ
### Q: I've run the playbook succesfully, but now I want to change the domain name/username/password. How can I do that?

Edit the variable files, install dependencies for the new user and re-run the playbook:

```
cd $HOME/kali-ansible
ansible-galaxy install -r requirements.yml
nano custom.yml
ansible-vault edit secret.yml
ansible-playbook run.yml
```

### Q: I'd like to completely automate the process of setting up the VPN on my machines. How can I do that?
1. Fork this repository
2. Fill out the `custom.yml` and `secret.yml` files, either by running the `bootstrap.sh` script, or editing the files manually
3. Remove `secret.yml` from .gitignore
4. Commit and push the changes

Consider making your repository private. Even though the Vault file is encrypted, it might be unsafe to make it publicly accessible.

### Q: I can't copy the SSH key to my Windows machine

On Windows, you might need to create the `C:\Users\<username>\.ssh` folder manually before running the commands at the end of the playbook:
```
mkdir C:\Users\<username>\.ssh
scp -P 22 root@<server-ip-address>:/tmp/id_ssh_ed25519 C:\Users\<username>\.ssh
ssh -p 22 <username>@<server-ip-address> -i C:\Users\<username>\.ssh\id_ssh_ed25519
```
