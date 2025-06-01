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

# completion styling
zstyle ':completion:*' matcher-list \
  'm:{a-z}={A-Z}' \
  'r:|=*' \
  'l:|=* r:|=*'
zstyle ':completion:*' list-colors "{(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:*:*' fzf-preview \
  'if [[ -d $realpath ]]; then
     tree -C -L 2 $realpath 2>/dev/null || ls -la --color=always $realpath
   elif [[ -f $realpath ]]; then
     bat --style=numbers --color=always $realpath 2>/dev/null || cat $realpath
   fi'

# ls aliases
alias ls='ls --color'
alias l='ls'
alias ll='ls -l'
alias lla="ls -al"

# Ensure globstar and no match errors are handled
setopt globstarshort
unsetopt nomatch

# fzf options
export FZF_DEFAULT_COMMAND="fd --type file --color=always"
export FZF_DEFAULT_OPTS="--ansi"
export FZF_PREVIEW_COMMAND="if [[ -d {} ]]; then tree -C -L 2 {} 2>/dev/null || ls -la --color=always {}; elif [[ -f {} ]]; then bat --style=numbers --color=always {} 2>/dev/null || cat {}; else echo {}; fi"
export FZF_CTRL_T_OPTS="--preview 'if [[ -d {} ]]; then tree -C -L 2 {} 2>/dev/null || ls -la --color=always {}; elif [[ -f {} ]]; then bat --style=numbers --color=always {} 2>/dev/null || cat {}; else echo {}; fi' --preview-window=right:60%"
eval "$(fzf --zsh)"

# source nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# SSH agent setup
# Start SSH agent if not running
if [ -z "$SSH_AUTH_SOCK" ] || ! ssh-add -l &>/dev/null; then
  # Look for existing agent
  if [ -f ~/.ssh/agent.env ]; then
    source ~/.ssh/agent.env >/dev/null
    # Check if agent still running
    if ! kill -0 $SSH_AGENT_PID &>/dev/null; then
      # Start a new agent
      eval "$(ssh-agent -s)" >/dev/null
      echo "export SSH_AUTH_SOCK=$SSH_AUTH_SOCK" >~/.ssh/agent.env
      echo "export SSH_AGENT_PID=$SSH_AGENT_PID" >>~/.ssh/agent.env
    fi
  else
    # No agent found, start a new one
    mkdir -p ~/.ssh
    eval "$(ssh-agent -s)" >/dev/null
    echo "export SSH_AUTH_SOCK=$SSH_AUTH_SOCK" >~/.ssh/agent.env
    echo "export SSH_AGENT_PID=$SSH_AGENT_PID" >>~/.ssh/agent.env
  fi

  # Add SSH key if exists and not already added
  if [ -f ~/.ssh/id_ed25519 ] && ! ssh-add -l | grep -q "id_ed25519"; then
    ssh-add -q ~/.ssh/id_ed25519 2>/dev/null
  fi
fi

# iTerm2 shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# PATH modifications
export PATH="$HOMEBREW_PREFIX/opt/llvm/bin:$PATH"
export PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"

# llvm
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

# Help llvm clang tidy find system headers
export SDKROOT=$(xcrun --show-sdk-path)

# Add pipx to path
export PATH="$PATH:/Users/abhinavchadaga/.local/bin"

# use oh-my-posh
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/pure.json)"

# start zoxide
eval "$(zoxide init --cmd cd zsh)"
