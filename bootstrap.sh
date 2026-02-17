#!/bin/bash

set -eu

if [ $# -ne 0 ]; then
    echo "usage: $0"
    exit 1
fi

# Installs
sudo apt update

sudo apt install rsync
sudo apt install gcc
sudo apt install python3 python-is-python3
sudo apt install sqlite3

## Docker
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo groupadd docker
sudo usermod -aG docker $USER

# Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt-get install terraform


read -p 'bootstrap: git email (e.g. johnsmith@email.com. leave empty to skip setting): ' GIT_USEREMAIL
read -p 'bootstrap: git username (e.g. John Smith. leave empty to skip setting): ' GIT_USERNAME
read -p 'bootstrap: ssh key to generate for github (e.g. "id_rsa" or "$HOSTNAME". leave empty to skip setting): ' SSH_KEY_NAME

set -x
SCRIPT_DIR=$(dirname $0)
rsync -r "${SCRIPT_DIR}/.bashrc" ${HOME}
rsync -r "${SCRIPT_DIR}/.bash_profile" ${HOME}
rsync -r "${SCRIPT_DIR}/.gitconfig" ${HOME}
rsync -r "${SCRIPT_DIR}/.vim" ${HOME}
rsync -r "${SCRIPT_DIR}/.vimrc" ${HOME}

if [ "$GIT_USERNAME" != "" ]; then
    git config --global user.name "${GIT_USERNAME}"
fi
if [ "$GIT_USEREMAIL" != "" ]; then
    git config --global user.email "${GIT_USEREMAIL}"
fi

if [ "${SSH_KEY_NAME}" != "" ]; then
    ssh-keygen \
        -t ed25519 \
        -C "${GIT_USEREMAIL}" \
        -N "" \
        -f "${HOME}/.ssh/${SSH_KEY_NAME}"

    cat <<EOT >> ~/.ssh/config 
Host *
  IdentityFile ~/.ssh/${SSH_KEY_NAME}
Host github.com
  User git
  Hostname github.com
  IdentityFile ~/.ssh/${SSH_KEY_NAME}
EOT
fi

# Configure NetworkManager to use Google DNS servers.
nmcli connection show
conn_name="$(nmcli -g NAME connection show --active | head -n 1)"
sudo nmcli con mod "${conn_name}" ipv4.dns "1.1.1.1 8.8.8.8"
sudo nmcli con mod "${conn_name}" ipv4.dns "1.1.1.1 8.8.8.8"
sudo nmcli con mod "${conn_name}" ipv4.ignore-auto-dns yes
sudo nmcli connection modify "${conn_name}" ipv6.dns "2001:4860:4860::8888 2001:4860:4860::8844"
sudo nmcli connection modify "${conn_name}" ipv6.ignore-auto-dns yes
sudo nmcli connection up "${conn_name}"


echo "Done. Now run 'source ~/.bashrc' to refresh your environment."
 
