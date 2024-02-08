#!/bin/bash

# SSM connect settings
mkdir /tmp/ssm
cd /tmp/ssm
wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
sudo dpkg -i amazon-ssm-agent.deb
sudo systemctl status amazon-ssm-agent
sudo systemctl enable amazon-ssm-agent
sudo systemctl restart amazon-ssm-agent

# Check the Linux distribution
if [ -f /etc/redhat-release ]; then
    # CentOS or Amazon Linux
    echo "Updating yum"
    yum update -y
    echo "Installing Nginx"
    yum install -y nginx
    systemctl enable nginx --now
    systemctl status nginx --no-pager
elif [ -f /etc/lsb-release ]; then
    # Ubuntu
    echo "Updating system using apt..."
    apt update
    echo "Installing Nginx using apt..."
    apt install -y nginx
    echo "Enabling and starting Nginx..."
    systemctl enable nginx --now
    systemctl status nginx --no-pager
else
    echo "Not found OS-release"
    exit 1
fi

echo "Nginx installation completed."