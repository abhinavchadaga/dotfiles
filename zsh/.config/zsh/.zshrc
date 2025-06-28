#!/usr/bin/env zsh

# install znit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"
# source fzf
source <(fzf --zsh)

# load completions
autoload -Uz compinit && compinit
zinit cdreplay -q

# plugins
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zdharma-continuum/fast-syntax-highlighting

# pure prompt
zinit ice pick"async.zsh" src"pure.zsh" 
zinit light sindresorhus/pure

# snippets
zinit snippet OMZP::git

HISTSIZE=5000
HISTFILE=$ZDOTDIR/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt globdots


# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --icons -T -L=2 --color=always $realpath'
zstyle ':fzf-tab:*' fzf-min-height 20
zstyle ':fzf-tab:*' fzf-preview-window 'right:70%:wrap'
zstyle ':completion:*:git-checkout:*' sort false

# load MacOS specific stuff
if [[ "$OSTYPE" == "darwin"* ]]; then
    source $ZDOTDIR/macos.zsh
fi

source $ZDOTDIR/aliases.zsh

# fzf environment variables
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_DEFAULT_OPTS="--ansi"
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'tree -C {}'"

export EDITOR="vim"

# enable emacs keybindings
bindkey -e

# fix option + left/right arrow in tmux
if [[ -n "$TMUX" ]]; then
  bindkey "^[[1;3D" backward-word   
  bindkey "^[[1;3C" forward-word    
fi
