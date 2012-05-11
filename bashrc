#{{{ Environment

	export EDITOR=vim PAGER=less BROWSER=w3m

	# Fix readline input
	export INPUTRC=~/.inputrc
	export WORDCHARS="_-~"

	# Add user bin to PATH
	if [ -d "$HOME/bin" ] ; then
			export PATH="$HOME/bin:$PATH"
	fi

#}}}
#{{{ Display and behaviour

	# Prompt
	#PS1="\e[0;34m\u\$ \e[m"
	PS1='\[\e]0;\w\a\]\[\e[32m\]\u@\h: \[\e[33m\]\w\[\e[0m\]\n\[\e[34m\]\$\[\e[0m\] '
	export PS1

	# Append rather than overwrite the history on disk
	shopt -s histappend

	# Ignore one Ctrl+D press (exits)
	export IGNOREEOF=1

	# Disable flow control
	stty -ixon

	# Disable bell sound
	setterm -bfreq 0

#}}}
#{{{ Aliases

	alias rc='source ~/.bashrc'

	alias cls='clear'
	alias quit='exit'

	# Directory listing
	alias ls='/bin/ls -b -CF --color=auto'
	alias la='ls -a'
	alias l='ls -lh'
	alias ll='ls -lha'

	# Shortcuts
	alias ..='cd ..'
	alias e=$EDITOR
	alias vi='vim'
	alias un='tar -xf'
	alias sc='screen'
	alias scr='screen -RdU'
	alias du='du -hs'

	# Nicely formatted date
	alias datex='date +"%Y-%m-%d (%A) @ %H:%M:%S"'

#}}}
#{{{ Git specific

	alias gs='git status'

	alias gpp='git pull --rebase && git push'
	alias gco='git checkout'

	alias ga='git add'
	alias gap='git add --patch'
	alias gaundo='git rm --cached -r' # remove from index (keep in working dir)

	alias gr='git reset HEAD' # unstage files

	alias grm='git ls-files -d -z | xargs -0 git update-index --remove'  # remove missing files

	alias gc='git commit'
	alias gcm='git commit -m'
	alias gcundo='git reset --soft HEAD^' # undo commit

	alias gca='git commit --amend'

	alias gd='git diff --color'
	alias gds='git diff --color --staged'

	alias gl='git log --color --name-status --pretty=format:"%Cred[%h] %an %Cblue(%ar)%n%Cgreen%s%n%b%Creset"'

#}}}
