sed -i 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config

sed -i 's/^.*10" //g' /root/ssh/authorized_keys

echo "P@ssw0rd!12#" | passwd root --stdin

systemctl restart sshd
