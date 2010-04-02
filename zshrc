# {{{ Environment setup

# {{{ Colors
autoload colors zsh/terminfo
colors
for COLOR in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE BLACK; do
eval PR_$COLOR='%{$fg[${(L)COLOR}]%}'
eval PR_BRIGHT_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
done
PR_RESET="%{${reset_color}%}";

LS_COLORS="no=00:fi=00:di=00;34:ln=01;36:pi=00;33:so=01;35:do=01;35:bd=00;33;01:cd=00;33;01:or=40;34;01:su=00;41:sg=00;43:tw=40;32:ow=40;32:st=37;44:ex=01;32:*.tar=01;33:*.tgz=01;33:*.gz=01;33:*.bz2=01;33:*.png=01;31:*.gif=01;31:*.jpg=01;31:*.jpeg=01;31:*.svg=01;31:*.bmp=01;31"
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# }}}

# {{{ Prompt
setopt prompt_subst

precmd() {
local termwidth; (( termwidth = ${COLUMNS} - 1 ))
local promptlen=${#${(%):-[%n@%m:%l] [%T]}}
local pwdlen=${#${(%):-%~}}
local pwdsize; (( pwdsize = $termwidth - $promptlen))
local pwdpad=0; (( pwdpad = $pwdsize - $pwdlen))
if [[ $pwdpad -lt 0 ]]; then
pwdpad=0;
fi

PROMPT="${PR_BRIGHT_BLACK}[${PR_RESET}${PR_GREEN}%n@%m${PR_BRIGHT_BLACK}:%l]\
${PR_RESET} ${PR_YELLOW}\
%$pwdsize<...<%~%<<${(r:$pwdpad:: :::)} \
${PR_BRIGHT_BLACK}[%T]${PR_RESET}
%(?::${PR_BRIGHT_BLACK}[${PR_BRIGHT_RED}%?${PR_RESET}${PR_BRIGHT_BLACK}]${PR_RESET} )\
${PR_BLUE}%(!.#.$) ${PR_RESET}"
}
# }}}

# {{{ Completion
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' completer _expand _complete _ignored #_approximate
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'
#zstyle ':completion:*' max-errors 1
zstyle :compinstall filename '/home/mogel/.zshrc'
autoload -Uz compinit && compinit
# }}}

# {{{ History
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt append_history hist_reduce_blanks
# }}}

# {{{ Bindings
bindkey -e
bindkey ' ' magic-space

# Up/down scrolls through history (search if possible)
bindkey "\e[B" history-search-forward
bindkey "\e[A" history-search-backward

# Word moving
# Ctrl+left/right
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word
# Alt+left/right
bindkey "\e[1;3C" forward-word
bindkey "\e[1;3D" backward-word

bindkey "\e[3;5~" backward-kill-word
bindkey "\e[3;3~" kill-word

# Page up/down
bindkey "\e[5~" backward-word
bindkey "\e[6~" forward-word
bindkey "\e[5;5~" backward-kill-word
bindkey "\e[6;5~" kill-word

# Ctrl-D clears line
bindkey "\C-d" kill-whole-line
# }}}

# {{{ Other options
setopt autocd
setopt noflowcontrol
setopt ignore_eof # dop not exit on Ctrl-D
WORDCHARS=
# }}}

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
alias du='du -h'

# Nicely formatted date
alias datex='date +"%Y-%m-%d (%A) @ %H:%M:%S"'
# }}}

# {{{ Program specific functionality

# {{{ Subversion shortcuts
svnci() {
	SVN_MFILE='svn-commit.tmp'
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
	if [[ "$1" != "" ]]; then
		echo "$*" >> svn-commit.tmp
	else
		cat svn-commit.tmp
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
	svn status | sed -e '/^!/!d' -e 's/^! *//' | tr '\n' '\0' | xargs --null -i -t svn rm
}
svnlog() {
	if [[ "$1" == "" ]]; then
		1=3
	fi
	svn log --verbose --limit $1
}
svnrestore() {
	if [[ "$3" == "" ]]; then
		3="."
	fi
	svn copy -r$1 $2@$1 $3
}
# }}}

# {{{ Ruby on rails shortcuts
alias rgen='script/generate'
alias rdes='script/destroy'
alias rcon='script/console'
alias rplug='script/plugin'
alias rdbmig='rake db:migrate'
# }}}

# }}}
