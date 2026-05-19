#!/bin/bash

# =============================================================================
# start_server.sh — Initial Setup & Hardening for Debian/Ubuntu Servers
# =============================================================================
#
# DESCRIPTION
#   Automates the initial configuration and basic hardening of a fresh
#   Debian/Ubuntu server. Run this script immediately after provisioning.
#
# USAGE
#   sudo bash start_server.sh
#
# REQUIREMENTS
#   - Debian or Ubuntu-based distribution
#   - Must be executed as root or via sudo
#   - Internet access (packages will be downloaded via apt)
#
# STEPS (all interactive — each section will prompt before applying)
#   1. Update and upgrade all system packages
#   2. Install essential CLI tools: btop, curl, wget, git, vim, nano, etc.
#   3. Create a new system user (optional)
#   4. Grant sudo privileges to the new user (optional)
#   5. Enable passwordless sudo for all users in the sudo group (optional)
#   6. SSH hardening:
#        - Disable root login                          [always applied]
#        - Disable password authentication             [optional — prompted]
#   7. Enable UFW firewall and allow OpenSSH
#
# WARNINGS
#   - If you choose to disable SSH password authentication (step 6), make sure
#     your SSH public key is already deployed on this server. Otherwise you
#     will lose remote access.
#   - Passwordless sudo applies to ALL current and future members of the sudo
#     group, not just the user created in this session.
#
# LOG
#   Full output is saved to: /var/log/start_server.log
#
# EXAMPLE
#   curl -O https://your-host/start_server.sh && sudo bash start_server.sh
#
# =============================================================================

set -euo pipefail

# Redirect all output to log file
exec > >(tee /var/log/start_server.log) 2>&1

# --- Root check ---
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root." >&2
    exit 1
fi

# =============================================================================
# SYSTEM UPDATE
# =============================================================================

echo "Updating system..."
apt update && apt upgrade -y

# =============================================================================
# ESSENTIAL TOOLS
# =============================================================================

echo "Installing essential tools..."
apt install -y \
    btop \
    curl \
    wget \
    git \
    vim \
    nano \
    net-tools \
    unzip \
    sudo \
    ufw

echo "Basic tools installed."

# =============================================================================
# USER CREATION
# =============================================================================

read -rp "Create a new user? (y/n): " NEWUSER

USERNAME=""

if [[ "$NEWUSER" == "y" || "$NEWUSER" == "Y" ]]; then

    read -rp "Enter the username to create: " USERNAME

    if id "$USERNAME" &>/dev/null; then
        echo "User $USERNAME already exists."
    else
        adduser "$USERNAME"
        echo "User $USERNAME created."
    fi

    # --- Add to sudo group ---
    read -rp "Should $USERNAME have sudo privileges? (y/n): " SUDOUSER

    if [[ "$SUDOUSER" == "y" || "$SUDOUSER" == "Y" ]]; then
        usermod -aG sudo "$USERNAME"
        echo "$USERNAME added to sudo group."
    fi

fi

# =============================================================================
# PASSWORDLESS SUDO (optional, applies to all users in the sudo group)
# =============================================================================

read -rp "Allow passwordless sudo for ALL users in the sudo group? (y/n): " NOPASS

if [[ "$NOPASS" == "y" || "$NOPASS" == "Y" ]]; then

    # Grant NOPASSWD to every member of the sudo group
    echo "%sudo ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/99-sudo-nopasswd
    chmod 440 /etc/sudoers.d/99-sudo-nopasswd

    # Validate sudoers syntax before applying
    visudo -cf /etc/sudoers
    visudo -cf /etc/sudoers.d/99-sudo-nopasswd

    echo "Passwordless sudo enabled for all users in the sudo group."
fi

# =============================================================================
# SSH HARDENING
# =============================================================================

echo "Configuring SSH..."

SSHD_CONFIG="/etc/ssh/sshd_config"

# Disable root SSH login (always applied)
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' "$SSHD_CONFIG"
echo "Root SSH login disabled."

# Ask whether to disable password authentication
echo ""
echo "  WARNING: Disabling SSH password authentication means only SSH key-based"
echo "  login will work. Make sure your public key is already on this server."
echo ""
read -rp "Disable SSH password authentication? (y/n): " DISABLEPASS

if [[ "$DISABLEPASS" == "y" || "$DISABLEPASS" == "Y" ]]; then
    sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' "$SSHD_CONFIG"
    echo "SSH password authentication disabled."
else
    sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' "$SSHD_CONFIG"
    echo "SSH password authentication kept enabled."
fi

# Restart SSH service (name varies by distro)
if systemctl list-units --type=service | grep -q 'sshd.service'; then
    systemctl restart sshd
else
    systemctl restart ssh
fi

echo "SSH configuration applied."

# =============================================================================
# FIREWALL
# =============================================================================

echo "Configuring firewall..."
ufw allow OpenSSH
ufw --force enable

echo "Firewall enabled."

# =============================================================================
# DONE
# =============================================================================

echo ""
echo "Setup completed successfully!"
echo "Log saved to: /var/log/start_server.log"