#!/bin/bash

set -euo pipefail

echo "Updating system..."
apt update && apt upgrade -y

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

# Ask for username

read -rp "Creater User (y/n): " NEWUSER

if [[ "$NEWUSER" == "y" || "$NEWUSER" == "Y" ]]; then
    read -rp "Enter the username to create: " USERNAME

    if id "$USERNAME" &>/dev/null; then
        echo "User $USERNAME already exists."
    else
        adduser "$USERNAME"
    fi
fi

read -rp "Enter the username to create: " USERNAME

if id "$USERNAME" &>/dev/null; then
    echo "User $USERNAME already exists."
else
    adduser "$USERNAME"
fi

# Ask if user should be sudo
read -rp "Should this user have sudo privileges? (y/n): " SUDOUSER

if [[ "$SUDOUSER" == "y" || "$SUDOUSER" == "Y" ]]; then
    usermod -aG sudo "$USERNAME"
    echo "$USERNAME added to sudo group."
fi

# Allow sudo without password for all sudo group users
read -rp "Allow passwordless sudo for ALL users in sudo group? (y/n): " NOPASS

if [[ "$NOPASS" == "y" || "$NOPASS" == "Y" ]]; then
    echo "%sudo ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/99-sudo-nopasswd
    chmod 440 /etc/sudoers.d/99-sudo-nopasswd

    # Validate sudoers syntax before continuing
    sudo visudo -cf /etc/sudoers
    sudo visudo -cf /etc/sudoers.d/99-sudo-nopasswd

    echo "Passwordless sudo enabled for all users in sudo group."
fi

echo "Configuring SSH..."

SSHD_CONFIG="/etc/ssh/sshd_config"

sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' "$SSHD_CONFIG"
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' "$SSHD_CONFIG"

systemctl restart ssh || systemctl restart sshd

echo "Root SSH login disabled."

echo "Configuring firewall..."
ufw allow OpenSSH
ufw --force enable

echo "Firewall enabled."

echo "Setup completed successfully!"