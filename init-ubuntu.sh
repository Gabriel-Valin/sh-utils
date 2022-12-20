apt update && apt upgrade

# Install Essentials Packages
apt-get -qq update && \
    apt-get -y install build-essential autoconf libtool && \
    apt-get install -y python-setuptools python-dev python3-dev && \
    apt-get install -y python-pip python3-pip && \
    apt-get install -y python-virtualenv unixodbc-dev libffi-dev git && \
    apt-get clean \
    rm -rf /var/lib/apt/lists/*

apt install git htop wget curl jq ssh openssh-server
apt install net-tools telnet sysstat tar screen ufw

# Automatic Update
apt install unattended-upgrades

sed -i 's|//      "${distro_id}:${distro_codename}-updates";|      "${distro_id}:${distro_codename}-updates";|g' /etc/apt/apt.conf.d/50unattended-upgrades
sed -i 's|//Unattended-Upgrade::Remove-Unused-Kernel-Packages "true";|Unattended-Upgrade::Remove-Unused-Kernel-Packages "true";|g' /etc/apt/apt.conf.d/50unattended-upgrades
sed -i 's|//Unattended-Upgrade::Mail "";|Unattended-Upgrade::Mail "gabrielvalincontato@gmail.com";|g' /etc/apt/apt.conf.d/50unattended-upgrades
sed -i 's|//Unattended-Upgrade::MailReport "on-change";|Unattended-Upgrade::MailReport "only-on-error";|g' /etc/apt/apt.conf.d/50unattended-upgrades
sed -i 's|//Unattended-Upgrade::Remove-New-Unused-Dependencies "true";|Unattended-Upgrade::Remove-New-Unused-Dependencies "true";|g' /etc/apt/apt.conf.d/50unattended-upgrades
sed -i 's|//Unattended-Upgrade::Automatic-Reboot "false";|Unattended-Upgrade::Automatic-Reboot "true";|g' /etc/apt/apt.conf.d/50unattended-upgrades
sed -i 's|//Unattended-Upgrade::Automatic-Reboot-Time "02:00";|Unattended-Upgrade::Automatic-Reboot-Time "05:00";|g' /etc/apt/apt.conf.d/50unattended-upgrades

echo 'APT::Periodic::Download-Upgradeable-Packages "1";' >> /etc/apt/apt.conf.d/20auto-upgrades
echo 'APT::Periodic::AutocleanInterval "7";' >> /etc/apt/apt.conf.d/20auto-upgrades

unattended-upgrades --dry-run

# Config SSH/OpenSSH
systemctl enable --now ssh
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config

# Create swapfile
dd if=/dev/zero of=/swapfile bs=1M count=1000
mkswap /swapfile
chown root:root /swapfile
chmod 0600 /swapfile
swapon /swapfileecho /swapfile swap swap defaults,discard 0 0 | tee -a /etc/fstab

# Configure Chrony (NTP - Network Time Protocol)
apt install chrony -y
timedatectl set-timezone America/Sao_Paulo
systemctl enable chrony
chrony sources

# Disabled SELINUX
/usr/sbin/setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

# Firewall Rules (UFW)
ufw default allow outgoing
ufw default deny incoming
ufw allow 22/tcp
ufw limit ssh comment "Rate limit for ssh connections on openssh server"

ufw enable
systemctl enable ufw

# Install Docker
apt-get install ca-certificates curl gnupg lsb-release
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Nginx
apt install nginx -y

echo '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' | base64 --decode | tee /etc/nginx/nginxconfig.io-gabrielvalindev.com.br.tar.gz > /dev/null
tar -xzvf nginxconfig.io-gabrielvalindev.com.br.tar.gz | xargs chmod 0644
openssl dhparam -out /etc/nginx/dhparam.pem 2048
mkdir -p /var/www/_letsencrypt
chown www-data /var/www/_letsencrypt
sed -i -r 's/(listen .*443)/\1; #/g; s/(ssl_(certificate|certificate_key|trusted_certificate) )/#;#\1/g; s/(server \{)/\1\n    ssl off;/g' /etc/nginx/sites-available/gabrielvalindev.com.br.conf
sudo nginx -t && sudo systemctl reload nginx
certbot certonly --webroot -d gabrielvalindev.com.br --email gabrielvalincontato@gmail.com -w /var/www/_letsencrypt -n --agree-tos --force-renewal
sed -i -r -z 's/#?; ?#//g; s/(server \{)\n    ssl off;/\1/g' /etc/nginx/sites-available/gabrielvalindev.com.br.conf
sudo nginx -t && sudo systemctl reload nginx
echo -e '#!/bin/bash\nginx -t && systemctl reload nginx' | sudo tee /etc/letsencrypt/renewal-hooks/post/nginx-reload.sh
sudo chmod a+x /etc/letsencrypt/renewal-hooks/post/nginx-reload.sh
sudo nginx -t && sudo systemctl reload nginx


reboot
