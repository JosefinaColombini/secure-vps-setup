#!/bin/bash
# UFW firewall configuration for secure VPS
# Description:
#   This script configures UFW to:
#     - Deny all incoming by default
#     - Allow WireGuard from anywhere (public)
#     - Restrict SSH ports to specific VPN peers
#     - Allow all outgoing traffic
#
# NOTE: Replace 10.0.0.10 with your WireGuard peer IPs.

# Reset existing rules
sudo ufw --force reset

# Default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow WireGuard (public port)
sudo ufw allow 51820/udp


# Allow SSH ONLY from specific WireGuard peers
sudo ufw allow in on wg0 from 10.0.0.10 to any port 22 proto tcp

# Allow Streamlit app ONLY via VPN interface
sudo ufw allow in on wg0 to any port 8501 proto tcp

# Enable firewall and logging
sudo ufw logging on
sudo ufw --force enable

# Show final status
sudo ufw status verbose
