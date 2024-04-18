#!/bin/bash
echo "Welcome to Aviatrix OCI Testing Flex VM" >> /etc/motd
echo "" >> /etc/motd
echo "" >> /etc/motd
echo "Copy autonomous db wallets to \$TNS_ADMIN" >> /etc/motd
echo "" >> /etc/motd

yum install iperf3 wget -y && \
cd /home/ubuntu && \

wget https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-basic-linux.x64-21.1.0.0.0.zip && \
wget https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-sqlplus-linux.x64-21.1.0.0.0.zip && \
unzip instantclient-basic-linux.x64-21.1.0.0.0.zip && \
unzip instantclient-sqlplus-linux.x64-21.1.0.0.0.zip && \

echo "export LD_LIBRARY_PATH=/home/ubuntu/instantclient_21_1" >> /home/ubuntu/.bash_profile && \
echo "export PATH=\$PATH:/home/ubuntu/instantclient_21_1" >> /home/ubuntu/.bash_profile && \
echo "export TNS_ADMIN=/home/ubuntu/instantclient_21_1/network/admin" >> /home/ubuntu/.bash_profile && \

chown ubuntu:ubuntu /home/ubuntu/.bash_profile && \
chown -R ubuntu:ubuntu /home/ubuntu/instant* && \
rm /home/ubuntu/*.zip

sudo hostnamectl set-hostname ${name}
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo echo ubuntu:${password} | /usr/sbin/chpasswd
sudo apt update -y
sudo apt upgrade -y
sudo apt-get -y install traceroute unzip build-essential git gcc hping3 apache2 net-tools
sudo apt autoremove

sudo systemctl restart apache2
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 80 -j ACCEPT
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 443 -j ACCEPT

sudo /etc/init.d/ssh restart
sudo echo "<html><h1>IAC Server OCI is awesome</h1></html>" > /var/www/html/index.html

