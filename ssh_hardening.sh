#!/bin/bash

set -e

echo "[*] Updating system..."
apt update -y && apt upgrade -y

echo "[*] Installing fail2ban..."
apt install -y fail2ban ufw

echo "[*] Configuring SSH..."
SSHD_CONFIG="/etc/ssh/sshd_config"

# Backup
cp $SSHD_CONFIG ${SSHD_CONFIG}.bak.$(date +%F)

# Disable root and password login
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' $SSHD_CONFIG
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' $SSHD_CONFIG
sed -i 's/^#\?PubkeyAuthentication.*/PubkeyAuthentication yes/' $SSHD_CONFIG

# Restrict users (optional: replace 'user1' with your actual username)
if ! grep -q "^AllowUsers" $SSHD_CONFIG; then
  echo "AllowUsers ubuntu" >> $SSHD_CONFIG
fi

# Change default port
NEW_PORT=2222
if ! grep -q "^Port" $SSHD_CONFIG; then
  echo "Port $NEW_PORT" >> $SSHD_CONFIG
else
  sed -i "s/^#\?Port .*/Port $NEW_PORT/" $SSHD_CONFIG
fi

# Limit idle sessions
echo "ClientAliveInterval 300" >> $SSHD_CONFIG
echo "ClientAliveCountMax 2" >> $SSHD_CONFIG

echo "[*] Restarting SSH..."
systemctl restart ssh

echo "[*] Configuring firewall..."
ufw allow $NEW_PORT/tcp
ufw enable

echo "[*] Configuring fail2ban..."
cat >/etc/fail2ban/jail.local <<EOF
[sshd]
enabled = true
port = $NEW_PORT
filter = sshd
logpath = /var/log/auth.log
maxretry = 5
bantime = 15m
findtime = 10m
EOF

systemctl enable fail2ban
systemctl restart fail2ban

echo "[+] SSH hardening complete."
