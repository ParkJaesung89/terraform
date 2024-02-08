export MASTER_USER=jsp
export MASTER_USER_PASSWORD=sjaksahffk.!

adduser $MASTER_USER -g wheel
echo $MASTER_USER:$MASTER_USER_PASSWORD | chpasswd

rsync -a /etc/ssh/sshd_config /root/HOSTWAY/
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config

systemctl restart sshd
