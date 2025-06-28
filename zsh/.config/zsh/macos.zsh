#!/usr/bin/env zsh

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

# natural text editing
if [[ "$TERM" == "alacritty" ]]; then
    bindkey "^[[1;9D" beginning-of-line
    bindkey "^[[1;9C" end-of-line
    bindkey "^[[1;3D" backward-word
    bindkey "^[[1;3C" forward-word
    bindkey "^[[3;10~" backward-kill-word
    bindkey "^[[3;3~" kill-word
fi
