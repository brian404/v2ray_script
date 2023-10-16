#!/bin/bash

# Configure iptables
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -F
sudo cp /etc/iptables/rules.v4 /etc/iptables/rules.v4.bak
sudo truncate -s 0 /etc/iptables/rules.v4

# Prompt user for domain name
read -p "Enter domain name: " domain_name

# Prompt user for panel username
read -p "Enter panel username: " username

# Prompt user for panel password
read -p "Enter panel password: " password

# Prompt user for panel port
read -p "Enter panel port: " port

# Update and upgrade system
apt update && apt upgrade -y

# Install required packages
apt install curl socat -y

# Install acme.sh
curl https://get.acme.sh | sh

# Set default CA server
~/.acme.sh/acme.sh --set-default-ca --server letsencrypt

# Register account
~/.acme.sh/acme.sh --register-account -m vicpku1@gmail.com

# Issue certificate
~/.acme.sh/acme.sh --issue -d $domain_name --standalone

# Install certificate
~/.acme.sh/acme.sh --installcert -d $domain_name --key-file /root/private.key --fullchain-file /root/cert.crt

# Install Nginx
apt install nginx -y

# Configure Nginx
cat > /etc/nginx/sites-available/mypanel <<EOL
server {
    listen 80;
    server_name $domain_name;

    location / {
        proxy_pass http://127.0.0.1:$port;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
    }
}
EOL

# Create a symbolic link to enable the site
ln -s /etc/nginx/sites-available/mypanel /etc/nginx/sites-enabled/

# Remove the default Nginx site
rm /etc/nginx/sites-enabled/default

# Test Nginx configuration
nginx -t

# Reload Nginx
systemctl reload nginx

# Run x-ui install script with user prompts
echo -e "y\n$username\n$password\n$port" | bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh)

# Print server access information
echo -e "\033[32mVisit http://$domain_name to access the panel.\033[0m"
