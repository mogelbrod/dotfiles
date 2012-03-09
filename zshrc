# {{{ Environment setup

# {{{ Environment
export EDITOR=vim PAGER=less BROWSER=w3m
export WORDCHARS="_-~"

# Disable flow control
stty -ixon -ixoff

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    export PATH="$HOME/bin:$PATH"
fi
# }}}

# {{{ Colors
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
# }}}

# {{{ Prompt
setopt prompt_subst

precmd() {
	# Title
	if [[ $TERM == (*xterm*|rxvt); ]]; then
		print -Pn "\e]0;[%n@%m] %~\a"
	fi

	local termwidth; (( termwidth = ${COLUMNS} - 1 ))
	local promptlen=${#${(%):-[%n@%m:%l] [%D{%H:%M}]}}
	local pwdlen=${#${(%):-%~}}
	local pwdsize; (( pwdsize = $termwidth - $promptlen))
	local pwdpad=0; (( pwdpad = $pwdsize - $pwdlen))
	if [[ $pwdpad -lt 0 ]]; then
		pwdpad=0;
	fi

	HCOLOR=$PR_GREEN
	[[ -n "${SSH_CONNECTION}" ]] && HCOLOR=$PR_CYAN

PROMPT="${PR_BRIGHT_BLACK}[${PR_RESET}${HCOLOR}%n@%m${PR_BRIGHT_BLACK}:%l]\
${PR_RESET} ${PR_YELLOW}\
%$pwdsize<...<%~%<<${(r:$pwdpad:: :::)} \
${PR_BRIGHT_BLACK}[%D{%H:%M}]${PR_RESET}
%(?::${PR_BRIGHT_BLACK}[${PR_BRIGHT_RED}%?${PR_RESET}${PR_BRIGHT_BLACK}]${PR_RESET} )\
${PR_BLUE}%(!.#.$) ${PR_RESET}"
}
# }}}

# {{{ Completion
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' completer _expand _complete _ignored #_approximate
#zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
#zstyle ':completion:*' max-errors 1
zstyle :compinstall filename '/home/mogel/.zshrc'
autoload -Uz compinit && compinit

setopt complete_in_word
setopt auto_param_slash auto_param_keys
# }}}

# {{{ History
HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=1000
setopt append_history hist_reduce_blanks
setopt inc_append_history share_history
# }}}

# }}}

# {{{ Bindings
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

# }}}

# {{{ Aliases

alias rc='source ~/.zshrc'
alias cls=clear
alias quit=exit

alias sp=roxterm

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
alias scr='screen -RdU'
alias sc='screen'
alias du='du -hs'

# cd which replaces substrings in PWD
function scd { cd `echo $PWD | sed s/$1/$2/` }

# Nicely formatted date
alias datex='date +"%Y-%m-%d (%A) @ %H:%M:%S"'

# Global aliases
alias -g M='| more'
alias -g L="| less"
alias -g G='| grep'

# }}}

# {{{ File handling
alias -s tex=$EDITOR txt=$EDITOR css=$EDITOR js=$EDITOR conf=$EDITOR
alias -s htm=$BROWSER html=$BROWSER
# }}}

# {{{ Program specific functionality

# {{{ Git
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gcm='git commit -m'

alias gca='git commit --amend'
alias gundo='git rm --cached -r ' # proper unstaging of files
alias gr='git reset HEAD'  # unstage files
alias gcundo='git reset --soft HEAD^'  # undo commit

alias gd='git diff --color'
alias gds='git diff --color --staged'

alias gl='git log --color --name-status --pretty=format:"%Cred[%h] %an %Cblue(%ar)%n%Cgreen%s%n%b%Creset"' alias gco='git checkout'

alias grm='git ls-files -d -z | xargs -0 git update-index --remove'  # remove missing files
# }}}

# {{{ Subversion shortcuts
svnbase() {
	SVN_MFILE='svn-commit.tmp'
	parent=""
	grandparent="."
	while [ -d "$grandparent/.svn" ]; do
			parent=$grandparent
			grandparent="$parent/.."
	done
	[ ! -z "$parent" ] && SVN_MFILE="${parent}/${SVN_MFILE}"
	echo $SVN_MFILE
}
svnci() {
	SVN_MFILE=$(svnbase)
	svn commit -F $SVN_MFILE
	if [ "$?" -eq 0 ]; then
		echo "##################################################"
		echo "Commit successful, message provided:"
		echo "##################################################"
		cat $SVN_MFILE
		echo "##################################################"
		rm $SVN_MFILE
	fi
}
svnm() {
	SVN_MFILE=$(svnbase)
	if [[ "$1" != "" ]]; then
		echo "$*" >> $SVN_MFILE
	else
		[[ -a "${SVN_MFILE}" ]] && cat $SVN_MFILE
	fi
}
svndiff() {
	svn diff $* | vim -R -
}
svncheck() {
	svnadd; svndel
	echo "## Done ##########################################"
}
svnadd() {
	echo "## Add: ##########################################"
	svn add . --force
}
svndel() {
	echo "## Remove: #######################################"
	svn status | sed -e '/^!/!d' -e 's/^! *//' | tr '\n' '\0' | xargs --null svn rm
}
svnlog() {
	if [[ "$1" == "" ]]; then
		1=3
	fi
	svn log --verbose --limit $1 -r HEAD:BASE
}
svnrestore() {
	if [[ "$3" == "" ]]; then
		3="."
	fi
	svn copy -r$1 $2@$1 $3
}
# }}}

# {{{ Ruby on rails shortcuts
alias rgen='script/rails generate'
alias rdes='script/rails destroy'
alias rcon='script/rails console'
alias rplug='script/rails plugin'
alias rdbmig='rake db:migrate'
# }}}

# }}}
