#!/bin/bash

# Replace example.com with your actual domain name
DOMAIN="nginx.brian72.eu.org"

# Install Nginx and V2Ray
sudo apt update
sudo apt install -y nginx
sudo apt install -y wget unzip
bash <(curl -L -s https://install.direct/go.sh)

# Configure Nginx to serve as a reverse proxy for V2Ray
sudo tee /etc/nginx/sites-available/$DOMAIN >/dev/null <<EOF
server {
    listen 80;
    listen [::]:80;
    server_name $DOMAIN;
    return 301 https://$DOMAIN$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name $DOMAIN;

    ssl_certificate /etc/v2ray/v2ray.crt;
    ssl_certificate_key /etc/v2ray/v2ray.key;
    ssl_protocols TLSv1.2 TLSv1.3;

    location / {
        proxy_pass http://127.0.0.1:10000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
EOF

# Enable the Nginx configuration and restart Nginx
sudo ln -s /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/
sudo systemctl restart nginx
