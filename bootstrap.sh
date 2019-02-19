#!/bin/bash

set -eux

read -p 'primary git path: ' GITROOT
read -p 'git username (e.g. John Smith): ' GIT_USERNAME
read -p 'git email (e.g. johnsmith@email.com): ' GIT_USEREMAIL

SCRIPT_DIR=$(dirname $0)
rsync -r "${SCRIPT_DIR}/.bashrc" ${HOME}
rsync -r "${SCRIPT_DIR}/.bash_profile" ${HOME}
rsync -r "${SCRIPT_DIR}/.gitconfig" ${HOME}
rsync -r "${SCRIPT_DIR}/.vim" ${HOME}
rsync -r "${SCRIPT_DIR}/.vimrc" ${HOME}

sed -i 's@{{GITROOT}}@'"${GITROOT}"'@g' ${HOME}/.bashrc
git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_USEREMAIL"
