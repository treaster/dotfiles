#!/bin/bash

set -eux

rsync -r ~/dotfiles/.bash_profile ~
rsync -r ~/dotfiles/.gitconfig ~
rsync -r ~/dotfiles/.vim ~
rsync -r ~/dotfiles/.vimrc ~

read -p 'git username (e.g. John Smith): ' GIT_USERNAME
read -p 'git email (e.g. johnsmith@email.com): ' GIT_USEREMAIL
git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_USEREMAIL"
