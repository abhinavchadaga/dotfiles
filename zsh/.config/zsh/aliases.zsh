#!/usr/bin/env zsh

# ls aliases
alias ls="eza -1 --color=always"
alias la="ls --all"
alias ll="ls --long --header --git --icons"
alias lla="ll --all"
alias lt="ls --tree --level=2 --git-ignore"

# make reloading zsh config easier
alias sz="source $ZDOTDIR/.zshrc"
