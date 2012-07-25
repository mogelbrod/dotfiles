#{{{ Environment

	export EDITOR=vim PAGER=less BROWSER=w3m
	export WORDCHARS="_-~"

	# Disable flow control
	stty -ixon -ixoff

	# Add user bin to PATH
	if [ -d "$HOME/bin" ] ; then
			export PATH="$HOME/bin:$PATH"
	fi

#}}}
#{{{ Colors

	autoload colors zsh/terminfo
	colors
	for COLOR in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE BLACK; do
		eval PR_$COLOR='%{$fg[${(L)COLOR}]%}'
		eval PR_BRIGHT_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
	done
	PR_RESET="%{${reset_color}%}";

	export LS_COLORS="no=00:fi=00:di=00;34:ln=01;36:pi=00;33:so=01;35:do=01;35:bd=00;33;01:cd=00;33;01:or=40;34;01:su=00;41:sg=00;43:tw=40;32:ow=40;32:st=37;44:ex=01;32:*.tar=01;33:*.tgz=01;33:*.gz=01;33:*.bz2=01;33:*.png=01;31:*.gif=01;31:*.jpg=01;31:*.jpeg=01;31:*.svg=01;31:*.bmp=01;31"
	#zstyle ':completion:*' list-colors ''
	#zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
	zmodload zsh/complist

#}}}
#{{{ Prompt

	setopt prompt_subst

	precmd() {
		# Title
		if [[ $TERM == (*xterm*|rxvt); ]]; then
			print -Pn "\e]0;[%n@%m] %~\a"
		fi

		local termwidth; (( termwidth = ${COLUMNS} - 1 ))
		local promptlen=${#${(%):-[%n@%m:%l] [%D{%H:%M:%S}]}}
		local pwdlen=${#${(%):-%~}}
		local pwdsize; (( pwdsize = $termwidth - $promptlen))
		local pwdpad=0; (( pwdpad = $pwdsize - $pwdlen))
		if [[ $pwdpad -lt 0 ]]; then
			pwdpad=0;
		fi

		local faded="${PR_BRIGHT_BLACK}"

		# User / host colorization
		local user_color=$PR_GREEN
		[[ "$USER" == "root" ]] && user_color=$PR_BRIGHT_RED
		local host_color=$PR_CYAN
		case $HOST in
			mogelserv) host_color=$PR_BRIGHT_GREEN ;;
			hallberg)  host_color=$PR_BRIGHT_BLUE ;;
		esac

		local user_host="${faded}[${PR_RESET}${user_host}${user_color}%n${faded}@${host_color}%m${faded}:%l]"
		local padded_cwd="${PR_RESET}${PR_YELLOW}%$pwdsize<...<%~%<<${(r:$pwdpad:: :::)}"
		local now="${faded}[%D{%H:%M:%S}]${PR_RESET}"
		local error_num="%(?::${faded}${PR_BRIGHT_RED}%?${PR_RESET}${faded}]${PR_RESET} )"
		local pr="${PR_BLUE}%(!.#.$) ${PR_RESET}"

		PROMPT="${user_host} ${padded_cwd} ${now}${error_num}${pr}"
	}

#}}}
#{{{ Completion

	zstyle ':completion:*' special-dirs true
	zstyle ':completion:*' completer _expand _complete _ignored #_approximate
	#zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'
	zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
	#zstyle ':completion:*' max-errors 1
	zstyle :compinstall filename '/home/mogel/.zshrc'
	autoload -Uz compinit && compinit

	setopt complete_in_word
	setopt auto_param_slash auto_param_keys

#}}}
#{{{ History

	HISTFILE=~/.histfile
	HISTSIZE=5000
	SAVEHIST=1000
	setopt append_history hist_reduce_blanks
	setopt inc_append_history share_history

#}}}
#{{{ Bindings

	bindkey -e
	bindkey ' ' magic-space

	# Up/down scrolls through history (search if possible)
	bindkey "\e[B" history-beginning-search-forward 
	bindkey "\e[A" history-beginning-search-backward

	# Word moving
	# Ctrl+left/right
	#bindkey "\e[1;5D" backward-word
	#bindkey "\e[1;5C" forward-word
	# Alt+left/right
	bindkey '[D' backward-word
	bindkey '[C' forward-word
	#bindkey "\e[1;3D" backward-word
	#bindkey "\e[1;3C" forward-word

	bindkey "\e[3;5~" backward-kill-word
	bindkey "\e[3;3~" kill-word
	bindkey "[3~" kill-word # alt-delete

	# Page up/down
	#bindkey "\e[5~" backward-word
	#bindkey "\e[6~" forward-word
	bindkey "\e[5;5~" backward-kill-word
	bindkey "\e[6;5~" kill-word

	# Ctrl-D clears line
	bindkey "\C-d" kill-whole-line

	# Alt-S inserts sudo at beginning of line
	insert_sudo () { zle beginning-of-line; zle -U "sudo " }
	zle -N insert-sudo insert_sudo
	bindkey "^[s" insert-sudo

#}}}
#{{{ Aliases

	alias rc='source ~/.zshrc'
	alias cls=clear
	alias quit=exit

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

	# cd which replaces substrings in PWD
	function scd { cd `echo $PWD | sed s/$1/$2/` }

	# Nicely formatted date
	alias datex='date +"%Y-%m-%d (%A) @ %H:%M:%S"'

	# Global aliases
	alias -g M='| more'
	alias -g L="| less"
	alias -g G='| grep'

	# Other useful aliases
	alias rails_routes='rake routes | vim - -c ":set nowrap buftype=nofile"'

#}}}
#{{{ File associations

	alias -s tex=$EDITOR txt=$EDITOR css=$EDITOR js=$EDITOR conf=$EDITOR
	alias -s htm=$BROWSER html=$BROWSER

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
