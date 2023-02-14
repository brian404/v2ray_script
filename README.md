Nginx-V2Ray Auto-Installation Script
This is an auto-installation script for setting up Nginx and V2Ray on a Ubuntu server, with support for TLS 1.2.

#How it works
The auto-installation script performs the following steps:

Installs Nginx and V2Ray on your server using apt.
Configures Nginx to serve as a reverse proxy for V2Ray, with support for TLS 1.2.
Generates SSL/TLS certificates using Certbot (optional).
The script is designed to be simple and easy to use, making it ideal for beginners who want to set up their own V2Ray server.

#Usage
To use the auto-installation script, follow these steps:

Log in to your Ubuntu server as a user with sudo privileges.

Download the installation script using wget

wget https://raw.githubusercontent.com/brian404/nginx_v2ray/main/setup.sh
Make the installation script executable:

chmod +x setup.sh
Run the installation script:

./setup.sh
Follow the prompts to configure Nginx and V2Ray on your server.

By default, the installation script configures Nginx to use a self-signed SSL/TLS certificate. If you want to use a valid SSL/TLS certificate from Let's Encrypt, you can run the script with the --certbot flag:

./setup.sh --certbot
This will install and configure Certbot, which will guide you through the process of obtaining a valid SSL/TLS certificate for your domain name.

#Conclusion
That's it! You now have a working Nginx and V2Ray server with support for TLS 1.2. If you encounter any issues, please refer to the troubleshooting section of the script or consult the V2Ray documentation for more information.
