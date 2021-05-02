#!/bin/bash

set -eu

GROOT_ARG=""
if [ $# -gt 1 ]; then
    echo "expected at most one argument."
    echo "usage: $0 [GROOT]"
    exit 1
fi

if [ $# -eq 1 ]; then
    GROOT_ARG=$1; shift
fi

if [ "$GROOT_ARG" == "" ] && [ "$GROOT" == "" ]; then
    # GROOT undefined, and no arg provided. Read from prompt.
    read -p 'path to monorepo git root ($GROOT): ' GROOT_ARG
elif [ "$GROOT_ARG" == "" ] && [ "$GROOT" != "" ]; then
    # No arg provided, but GROOT already defined. Just use the same thing again.
    echo 'Inferring $GROOT from existing environment'
    GROOT_ARG="$GROOT"
elif [ "$GROOT_ARG" != "" ] && [ "$GROOT" == "$GROOT_ARG" ]; then
    # Arg provided, matches existing GROOT. No action needed.
    echo 'Specified GROOT matches existing GROOT. No change to environment.'
elif [ "$GROOT_ARG" != "" ] && [ "$GROOT" != "$GROOT_ARG" ]; then
    # Arg provided, differs from existing GROOT.
    echo "Overriding existing GROOT with new value. (old: $GROOT, new: $GROOT_ARG)"
fi

GIT_USERNAME=$1; shift
if [ "$GIT_USERNAME" == "" ]; then
	read -p 'git username (e.g. John Smith): ' GIT_USERNAME
fi

GIT_USEREMAIL=$1; shift
if [ "$GIT_USEREMAIL" == "" ]; then
	read -p 'git email (e.g. johnsmith@email.com): ' GIT_USEREMAIL
fi

set -x

SCRIPT_DIR=$(dirname $0)
rsync -r "${SCRIPT_DIR}/.bashrc" ${HOME}
rsync -r "${SCRIPT_DIR}/.bash_profile" ${HOME}
rsync -r "${SCRIPT_DIR}/.gitconfig" ${HOME}
rsync -r "${SCRIPT_DIR}/.vim" ${HOME}
rsync -r "${SCRIPT_DIR}/.vimrc" ${HOME}

sed -i 's@{{GROOT}}@'"${GROOT_ARG}"'@g' ${HOME}/.bashrc
git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_USEREMAIL"
