#!/bin/bash

echo "================================================"
echo "   Pi-Hole + Tailscale + Unbound + UFW Setup"
echo "================================================"
echo ""

# Update system
echo "[1/5] Updating system packages..."
sudo apt update && sudo apt upgrade -y
echo ""

# Install Pi-Hole
echo "[2/5] Installing Pi-Hole..."
echo "      The installer will ask you some questions:"
echo "      - Confirm your static IP when prompted"
echo "      - Choose Cloudflare as your DNS provider"
echo "      - Choose Level 2 for privacy settings"
echo ""
curl -sSL https://install.pi-hole.net | bash
echo ""

# Install Tailscale
echo "[3/5] Installing Tailscale..."
curl -fsSL https://tailscale.com/install.sh | sh
echo ""

# Start Tailscale
echo "      A link will appear — open it in your browser to authenticate."
echo ""
sudo tailscale up
echo ""

# Install and configure Unbound
echo "[4/5] Installing and configuring Unbound..."
sudo apt install unbound -y

sudo tee /etc/unbound/unbound.conf.d/pi-hole.conf > /dev/null <<EOF
server:
    verbosity: 0
    interface: 127.0.0.1
    port: 5335
    do-ip4: yes
    do-udp: yes
    do-tcp: yes
    do-ip6: no
    prefer-ip6: no
    harden-glue: yes
    harden-dnssec-stripped: yes
    use-caps-for-id: no
    edns-buffer-size: 1232
    prefetch: yes
    num-threads: 1
    so-rcvbuf: 1m
    private-address: 192.168.0.0/16
    private-address: 169.254.0.0/16
    private-address: 172.16.0.0/12
    private-address: 10.0.0.0/8
    private-address: fd00::/8
    private-address: fe80::/10
EOF

sudo service unbound restart
echo ""
echo "      Unbound installed. Remember to point Pi-Hole DNS to 127.0.0.1#5335"
echo ""

# Install and configure UFW
echo "[5/5] Setting up UFW firewall..."
sudo apt install ufw -y
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 53
sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow in on tailscale0
sudo ufw enable
echo ""

echo "================================================"
echo "   Setup complete!"
echo "   Pi-Hole admin: http://YOUR_PI_IP/admin"
echo "   Point Pi-Hole DNS to: 127.0.0.1#5335"
echo "   Don't forget to configure DNS in Tailscale dashboard!"
echo "================================================"
