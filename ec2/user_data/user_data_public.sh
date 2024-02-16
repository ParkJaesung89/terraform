#!/bin/bash
mkdir /test
touch /test/test.txt
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
useradd jsp
echo "P@ssw0rd12#" | passwd jsp --stdin
systemctl restart sshd