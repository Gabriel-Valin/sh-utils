# Run apt update

sudo apt update

# Then add the GPG key for the official Docker repository to your system:

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Removing old versions from Docker

sudo apt-get remove docker docker-engine docker.io containerd runc

# Allow apt use HTTPS

sudo apt install apt-transport-https ca-certificates curl software-properties-common

# Add Docker repository to APT Sources

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

# Docker info if installation was successfull
# Output 

apt-cache policy docker-ce

# Installing docker

sudo apt install docker-ce -y

# System Docker Status

sudo systemctl status docker

# Add you user to Docker group

sudo usermod -aG docker ${USER}
su - ${USER}

# Display you user from Docker group

groups docker 
