#!/usr/bin/env zsh

# natural text editing
if [[ "$TERM" == "alacritty" ]]; then
    bindkey "^[[1;9D" beginning-of-line
    bindkey "^[[1;9C" end-of-line
    bindkey "^[[1;3D" backward-word
    bindkey "^[[1;3C" forward-word
    bindkey "^[[3;10~" backward-kill-word
    bindkey "^[[3;3~" kill-word
fi

# orbstack integration
if command -v orb &>/dev/null; then
    source ~/.orbstack/shell/init.zsh 2>/dev/null || true
fi

# fix option + left/right arrow in tmux
if [[ -n "$TMUX" ]]; then
  bindkey "^[[1;3D" backward-word   
  bindkey "^[[1;3C" forward-word    
fi