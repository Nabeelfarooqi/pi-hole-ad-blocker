Pi-Hole + Tailscale + Unbound + UFW Network-Wide Ad Blocker

A Raspberry Pi setup that blocks ads across your entire network, extends protection anywhere via VPN, uses recursive DNS for privacy, and secures the Pi with a firewall.

Hardware Required
- Raspberry Pi Zero 2 W
- Micro SD card
- Power supply

Step 1: Flash the SD Card

1. Download and install Raspberry Pi Imager from raspberrypi.com/software onto your Mac or whatever device you are using
2. Insert your Micro SD card into your device
3. Open the Imager and select your device, Pi Zero 2 W
4. Before writing, configure the following settings:
   - Set a username and hostname, for example username@hostname.local
   - Enable SSH
   - Enter your WiFi SSID and password
5. Write the image to the SD card
6. Once finished, eject the SD card and insert it into your Pi
7. Plug the Pi into a power supply

Step 2: Connect to Your Pi via SSH

From your Mac terminal run:

ssh username@hostname.local

When prompted type yes to confirm the connection. Enter your password and you should be connected.

Step 3: Set a Static IP

Pi-Hole works best with a static IP so its address never changes on your network.

1. Open your router settings via your router app or by navigating to your router IP in a browser. Common addresses are 192.168.1.1, 192.168.0.1, or 10.0.0.1
2. Find the IP reservation or DHCP reservation setting
3. Reserve a static IP for your Raspberry Pi
4. Note this IP down, you will need it during Pi-Hole setup

No port forwarding is needed. Tailscale handles remote access without it.

Step 4: Run the Setup Script

Once connected to your Pi via SSH run:

chmod +x setup.sh
./setup.sh

The script will walk you through installing Pi-Hole, Tailscale, Unbound, and UFW in order. During the Pi-Hole installer you will be prompted to:
- Confirm your static IP
- Choose an upstream DNS provider, select Cloudflare or research other options like Google or OpenDNS
- Choose a privacy level, select Level 2 - Hide domains and clients

The script is intended for a fresh install. It is safe to rerun as Pi-Hole will just update if already installed.

Step 5: Set Pi-Hole Web Interface Password

At the end of the Pi-Hole installation the terminal will display a temporary password for the web interface. You can use this to log in or set your own with:

sudo pihole setpassword

Then access the web interface at:

http://YOUR_PI_IP/admin

Step 6: Authenticate Tailscale

After Pi-Hole installs the script will run Tailscale and output an authentication link. Open it in your browser to authenticate. Once done your Pi will appear in your Tailscale dashboard.

Step 7: Configure Tailscale DNS

1. Open your Tailscale dashboard at https://login.tailscale.com/admin
2. Copy the IP address of your Pi from the devices list
3. Navigate to the DNS tab
4. Under Nameservers click Add nameserver then Custom
5. Paste your Pi Tailscale IP and save
6. Enable Override DNS servers

This routes all DNS traffic through your Pi-Hole when connected to Tailscale, giving you network-wide ad blocking from anywhere.

Step 8: Configure Unbound as Recursive DNS

After the script runs, point Pi-Hole to use Unbound instead of an upstream provider like Cloudflare.

1. Go to your Pi-Hole admin panel at http://YOUR_PI_IP/admin
2. Navigate to Settings then DNS
3. Uncheck all upstream DNS providers
4. Under Custom DNS servers add: 127.0.0.1#5335
5. Save

To verify Unbound is working run:

dig pi-hole.net @127.0.0.1 -p 5335

You should see NOERROR in the response.

Step 9: UFW Firewall

The script automatically configures UFW with the following rules:
- Blocks all unsolicited incoming traffic
- Allows SSH, DNS, HTTP, HTTPS
- Allows all Tailscale traffic

To check firewall status at any time run:

sudo ufw status

Step 10: Add Additional Blocklists (Optional)

1. Go to Pi-Hole admin panel
2. Navigate to Group Management then Adlists
3. Paste a raw blocklist URL and click Add
4. Go to Tools then Update Gravity to apply

Recommended blocklist:
https://raw.githubusercontent.com/hagezi/dns-blocklists/main/hosts/pro.txt

After adding lists run:

sudo pihole -g
