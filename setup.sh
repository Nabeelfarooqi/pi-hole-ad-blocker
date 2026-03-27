#!/bin/bash

echo "================================================"
echo "   Pi-Hole + Tailscale Setup Script"
echo "================================================"
echo ""

# Update system
echo "[1/4] Updating system packages..."
sudo apt update && sudo apt upgrade -y
echo ""

# Install Pi-Hole
echo "[2/4] Installing Pi-Hole..."
echo "      The installer will ask you some questions:"
echo "      - Confirm your static IP when prompted"
echo "      - Choose Cloudflare as your DNS provider"
echo "      - Choose Level 2 for privacy settings"
echo ""
curl -sSL https://install.pi-hole.net | bash
echo ""

# Install Tailscale
echo "[3/4] Installing Tailscale..."
curl -fsSL https://tailscale.com/install.sh | sh
echo ""

# Start Tailscale
echo "[4/4] Starting Tailscale..."
echo "      A link will appear — open it in your browser to authenticate."
echo ""
sudo tailscale up

echo ""
echo "================================================"
echo "   Setup complete!"
echo "   Pi-Hole admin: http://YOUR_PI_IP/admin"
echo "   Don't forget to configure DNS in Tailscale dashboard!"
echo "================================================"
