if [[ "$PAGER" == "head -n 10000 | cat" || "$COMPOSER_NO_INTERACTION" == "1" ]]; then
  return
fi

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

typeset -A ZINIT
ZINIT[NO_ALIASES]=1
source "${ZINIT_HOME}/zinit.zsh"

zinit ice depth=1

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# load pure prompt
autoload -U promptinit; promptinit
prompt pure

# Add in snippets
zinit snippet OMZP::git
[[ "$(uname -a)" == *"Ubuntu"* ]] && zinit snippet OMZP::ubuntu
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Enable fzf-tab fuzzy path completion
export FZF_COMPLETION_TRIGGER='**'

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'


setopt globstarshort
unsetopt nomatch

# fzf options
# export FZF_DEFAULT_COMMAND="fd --type file --color=always"
# export FZF_DEFAULT_OPTS="--ansi"
# export FZF_PREVIEW_COMMAND="if [[ -d {} ]]; then tree -C -L 2 {} 2>/dev/null || ls -la --color=always {}; elif [[ -f {} ]]; then bat --style=numbers --color=always {} 2>/dev/null || cat {}; else echo {}; fi"
# export FZF_CTRL_T_OPTS="--preview 'if [[ -d {} ]]; then tree -C -L 2 {} 2>/dev/null || ls -la --color=always {}; elif [[ -f {} ]]; then bat --style=numbers --color=always {} 2>/dev/null || cat {}; else echo {}; fi' --preview-window=right:60%"
eval "$(fzf --zsh)"

# PATH modifications

if [[ "$OS_TYPE" == "darwin"* ]] && command -v brew > /dev/null 2>&1; then
  eval "$(brew shellenv)"
  export PATH="$HOMEBREW_PREFIX/opt/llvm/bin:$PATH"
  export PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
  export PATH="$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin:$PATH"
  export PATH="$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin:$PATH"

  if brew list llvm > /dev/null 2>&1; then
    # llvm stuff
    export LDFLAGS="-L$HOMEBREW_PREFIX/opt/llvm/lib"
    export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/llvm/include"
    export SDKROOT=$(xcrun --show-sdk-path)
  fi
fi

# start zoxide
eval "$(zoxide init --cmd cd zsh)"

# use vscode as the default editor
export EDITOR="cursor"

# ALPACA API keys
export ALPACA_API_KEY=PKP319BYH9P2XVDKJM95
export ALPACA_API_SECRET=Ye3uaMtL1TviMeKIZA8gGNtCdDNX4xyolVmkqdPH

# GITHUB TOKEN
export GITHUB_TOKEN=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

# ls aliases
alias ls='ls --color'
alias l='ls'
alias la="ls -a"
alias ll='ls -l'
alias lla="ls -al"
alias lt='tree -a -C -L 2 -I ".git|node_modules|.DS_Store|venv|.venv"'

