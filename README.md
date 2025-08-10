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
```bash
# Update packages
sudo apt update && sudo apt upgrade -y

# Created new user
sudo

# Config SSH connection
```

### 2. Basic Firewall Configuration (UFW)
See ufw-rules.sh for exac rules

