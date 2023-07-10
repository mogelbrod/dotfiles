export LC_ALL=en_US.UTF-8
export WORDCHARS="_-~"

export MANPAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""
export EDITOR=vim PAGER=less BROWSER=w3m

[ -n "$VSCODE_INJECTION" ] && command -v code &> /dev/null && export EDITOR="code --wait"

# Include .bashrc if running bash
[ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"

# Add local bin dirs to path
if [ -d "$HOME/bin" ]; then
  export PATH="$HOME/bin:$PATH"
fi

# Load local .profile
[ -f "$HOME/.profile.local" ] && . "$HOME/.profile.local"