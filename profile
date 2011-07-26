# Include .bashrc if running bash
if [ -n "$BASH_VERSION" ]; then
	if [ -f "$HOME/.bashrc" ]; then
		. "$HOME/.bashrc"
	fi
fi

# Set PATH so that it includes user's private bin (if it exists)
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
