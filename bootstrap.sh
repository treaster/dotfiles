#!/bin/bash

set -eux

SCRIPT_DIR=$(dirname $0)
rsync -r "${SCRIPT_DIR}/.bash_profile" ~
rsync -r "${SCRIPT_DIR}/.gitconfig" ~
rsync -r "${SCRIPT_DIR}/.vim" ~
rsync -r "${SCRIPT_DIR}/.vimrc" ~

read -p 'git username (e.g. John Smith): ' GIT_USERNAME
read -p 'git email (e.g. johnsmith@email.com): ' GIT_USEREMAIL
git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_USEREMAIL"
