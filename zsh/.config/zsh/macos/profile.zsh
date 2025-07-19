#!/usr/bin/env zsh

# Homebrew setup
eval "$(/opt/homebrew/bin/brew shellenv)"

# llvm setup
if command -v brew &>/dev/null && brew --prefix llvm &>/dev/null; then
    export PATH="$(brew --prefix llvm)/bin:$PATH"
    export LDFLAGS="-L$(brew --prefix llvm)/lib -L$(brew --prefix llvm)/lib/c++ -L$(brew --prefix llvm)/lib/unwind -lunwind"
    export CPPFLAGS="-I$(brew --prefix llvm)/include"
fi

# gnu utils
export PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
export PATH="$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin:$PATH"

# help llvm clang find macos headers
export SDKROOT=$(xcrun --show-sdk-path)

# claude installation
alias claude="$HOME/.local/state/claude/launcher/claude-v0.0.8.sh"

