#!/bin/bash

sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    
useradd -m -d /home/jsp -s /bin/bash jsp
echo 'jsp:P@ssw0rd12#' | sudo chpasswd
usermod -aG sudo jsp

systemctl restart sshd
    
# nginx
apt update
apt install -y nginx
systemctl enable nginx --now
systemctl status nginx --no-pager
echo "test-page2" > /var/www/html/index.html

echo "Nginx installation completed."
