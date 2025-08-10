# Secure VPS Setup for Small Retail Business

This project documents the configuration and deployment of a secure Linux-based VPS for a small retail store.  
The server hosts a custom automation app, supports secure remote management via VPN, and includes automated backups.

---

## Overview
- **OS:** Debian
- **Security:** UFW, WireGuard VPN
- **Deployment:** Docker, Streamlit
- **Automation:** Rclone, SCP, Cron
- **Backups:** Encrypted cloud storage via Rclone

---

## Architecture Diagram


---

## Setup Steps

### 1. Server Provisioning
**- Basics**
```bash
# Update packages
sudo apt update && sudo apt upgrade -y

# Running as root for daily admin is insecure, so we create a new sudo-enabled user
sudo adduser adminuser
sudo usermod -aG sudo adminuser

```
**- Install core packages**

   Docker: Chose for containerized deployment for easy isolation and portability. Installed the latest Docker Engine & Compose plugin from the official Docker repository (https://docs.docker.com/engine/install/debian/). 
   You can check the commands here [install-docker.sh](install-docker.sh)
   
  ``` bash
    # Enable Docker to start on boo
    sudo systemctl enable --now docker

    #Check that everything's running ok
    docker --version && docker compose version
  ```

   WireGuard: We wanted a fast-to-setup VPN for secure remote access.
  ```bash
    # Install WireGuard VPN
    sudo apt install -y wireguard
  ```

   UFW: Provides a simple interface for managing firewall rules and limiting exposure.
  ```bash
    # Install UFW firewall
    sudo apt install -y ufw
  ```

**- SSH Configuration & Key Generation:**
```bash
  # Edit SSH configuration to disable root login and password-based authentication
  sudo nano /etc/ssh/sshd_config
  # Set: PermitRootLogin no
  # Set: PasswordAuthentication no
  
  # Reload SSH to apply changes
  sudo systemctl reload ssh
  
  # Generate SSH key pair on client machine
  ssh-keygen -t ed25519 -C "custom_name/id"
  
  # Copy public key to server
  ssh-copy-id -i ~/.ssh/your_key_name.pub user@your_server_ip
```

### 2. Basic Firewall Configuration (UFW)
See [ufw-rules.sh](ufw-rules.sh) for exact rules, including:
  - Deny all incoming by default
  - Allow WireGuard from anywhere
  - Restrict SSH & app ports to specific VPN peers
  - Allow all outgoing traffic

### 3. VPN Setup (WireGuard)
Configure /etc/wireguard/wg0.conf for server & peers (check [wg-rules.sh](wg-rules.sh))

Start WireGuard after setting up all config:
``` bash
sudo systemctl enable --now wg-quick@wg0
```
And check everything's working properly:
``` bash
ip a show wg0
# Should show the IP range you chose

sudo wg
# Check connections and config
```

### 4. Docker Deployment for Streamlit App
I followed the docs from Streamlit https://docs.streamlit.io/deploy/tutorials/docker

### 5. Backup Automation on the Cloud
We had a very low budget so we decided to backup the VPS on Google Drive with rclone, see [backup-script.sh](backup-script.sh) for automated Rclone backups.
- Set cron job:
``` bash
crontab -e
# Example: backup at midnight daily
0 0 * * * /path/to/backup-script.sh
```
