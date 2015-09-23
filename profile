# Include .bashrc if running bash
[ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"

# Set PATH so that it includes user's private bin (if it exists)
[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"

# Load local .profile
[ -f "$HOME/.profile.local" ] && . "$HOME/.profile.local"
