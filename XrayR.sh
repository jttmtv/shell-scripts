# init
sudo apt update && sudo apt upgrade -y
apt-get install git wget curl ufw vim htop -y
mkdir scripts
cd scripts

# enable bbr
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p

# ufw part
echo y | ufw reset
echo y | ufw enable
ufw allow ssh
ufw allow 443/tcp
ufw allow 443/udp
ufw allow 8388/tcp
ufw allow 8388/udp
ufw allow 12393/tcp
ufw allow 12393/udp
ufw reload

# add swap (2GB default)
wget https://www.moerats.com/usr/shell/swap.sh && chmod +x swap.sh
echo -e "1\n2048\n" | ./swap.sh

# optimize mem
sed -i 's/#Storage=auto/Storage=none/g' /etc/systemd/journald.conf
systemctl restart systemd-journald

# cron
service cron start
echo '#!/bin/bash' > free.sh
echo 'PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin' >> free.sh
echo 'export PATH' >> free.sh
echo 'echo 1 > /proc/sys/vm/drop_caches' >> free.sh
echo 'echo 2 > /proc/sys/vm/drop_caches' >> free.sh
echo 'echo 3 > /proc/sys/vm/drop_caches' >> free.sh
chmod +x free.sh
crontab -l > mycron
echo '30 3 * * *  /root/scripts/free.sh' >> mycron
crontab mycron
rm mycron
service cron restart

# install XrayR
curl -sSL https://get.docker.com/ | sh
systemctl start docker
systemctl enable docker
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
git clone https://github.com/Misaka-blog/XrayR-script.git

# check netflix
wget -O nf.sh https://github.com/sjlleo/netflix-verify/releases/download/2.61/nf_2.61_linux_amd64 && chmod +x nf.sh && clear && ./nf.sh

# finish
./free.sh
cd ..
rm -rf XrayR.sh
