# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

EDITOR=vim

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# Prevent bash from escaping $ for vars on tab completion
shopt -s direxpand

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=200000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

alias grep='grep --color=auto'
alias ls='ls -G'

export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n$ '
alias ls='ls --color=auto'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

LS_COLORS='ow=01;34;40'
export LS_COLORS

export GROOT="{{GROOT}}"
export GOROOT=$HOME/go
export GOPATH=${GROOT}/go

# TODO: Fill in private repos appropriately
# export GOPRIVATE="github.com/[USERNAME]"

export PATH=$HOME/bin:$HOME/.local/bin:${GOROOT}/bin:$PATH
go env -w GO111MODULE=auto
