# Include .bashrc if running bash
[ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"

# Add local bin dirs to path
if [ -d "$HOME/bin" ]; then
  export PATH="$HOME/bin:$PATH"
fi


# Load local .profile
[ -f "$HOME/.profile.local" ] && . "$HOME/.profile.local"
