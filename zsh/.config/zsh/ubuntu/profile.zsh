#!/usr/bin/env zsh

# add neovim to path

if [[ -d "/opt/nvim-linux-x86_64" ]]; then
    export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
fi
