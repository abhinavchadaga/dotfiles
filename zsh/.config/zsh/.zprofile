# PATH modifications
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# env variables
export EDITOR="code"

# load MacOS specific env vars
if [[ "$OSTYPE" == "darwin"* ]]; then
    source $ZDOTDIR/macos/profile.zsh
fi