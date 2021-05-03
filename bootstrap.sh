#!/bin/bash

set -eu

GROOT_ARG=""
if [ $# -gt 3 ]; then
    echo "expected at most three arguments."
    echo "usage: $0 [GIT_USERNAME] [GIT_USEREMAIL] [GROOT]"
    exit 1
fi

if [ $# -eq 1 ]; then
    GROOT_ARG=$1; shift
fi

# Check if GROOT is entirely unset, and set to empty string if necessary.
if [ -z "${GROOT+x}" ]; then
    GROOT=""
fi

if [ "$GROOT_ARG" == "" ] && [ "$GROOT" == "" ]; then
    # GROOT undefined, and no arg provided. Read from prompt.
    read -p "path to monorepo git root (\$GROOT) [default=$GROOT]: " GROOT_ARG
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

read -p 'git email (e.g. johnsmith@email.com. leave empty to skip setting): ' GIT_USEREMAIL
read -p 'git username (e.g. John Smith. leave empty to skip setting): ' GIT_USERNAME

set -x
SCRIPT_DIR=$(dirname $0)
rsync -r "${SCRIPT_DIR}/.bashrc" ${HOME}
rsync -r "${SCRIPT_DIR}/.bash_profile" ${HOME}
rsync -r "${SCRIPT_DIR}/.gitconfig" ${HOME}
rsync -r "${SCRIPT_DIR}/.vim" ${HOME}
rsync -r "${SCRIPT_DIR}/.vimrc" ${HOME}

sed -i 's@{{GROOT}}@'"${GROOT_ARG}"'@g' ${HOME}/.bashrc

if [ "$GIT_USERNAME" != "" ]; then
    git config --global user.name "$GIT_USERNAME"
fi
if [ "$GIT_USEREMAIL" != "" ]; then
    git config --global user.email "$GIT_USEREMAIL"
fi

echo "Done. Now run 'source ~/.bashrc' to refresh your environment."
