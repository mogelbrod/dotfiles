# Include .bashrc if running bash
[ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"

# Load local .profile
[ -f "$HOME/.profile.local" ] && . "$HOME/.profile.local"
