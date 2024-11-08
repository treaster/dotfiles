#!/bin/bash

set -eu

GROOT_ARG=""
if [ $# -ne 0 ]; then
    echo "usage: $0"
    exit 1
fi

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
Host github.com
  User git
  Hostname github.com
  IdentityFile ~/.ssh/${SSH_KEY_NAME}
EOT
fi


echo "Done. Now run 'source ~/.bashrc' to refresh your environment."
