############################################################
## Setup environment
############################################################

# Add user bin to path
#if [ -d ~/bin ] ; then
#    if [[ ! "$PATH" =~ `cd ~/bin; pwd` ]] ; then
#		PATH=~/bin:$PATH
#    	export PATH
#	fi
#fi

# Change promt
#PS1="\e[0;34m\u\$ \e[m"
PS1='\[\e]0;\w\a\]\[\e[32m\]\u@\h: \[\e[33m\]\w\[\e[0m\]\n\[\e[34m\]\$\[\e[0m\] '
export PS1

# Fix readline input
export INPUTRC=~/.inputrc

# Append rather than overwrite the history on disk
shopt -s histappend

# Ignore one Ctrl+D press (exits)
export IGNOREEOF=1

# Disable flow control
stty -ixon

# Fix the backspace
#stty erase '^?'

# Disable bell sound
setterm -bfreq 0

############################################################
## Basic aliases
############################################################

alias cls='clear'
alias quit='exit'
alias ls='/bin/ls --color=always'
alias l='ls -lh'
alias la='ls -a'
alias ll='ls -lah'

# Applications
alias un='tar -xf'
alias vi='vim'

alias reload='source ~/.bashrc'

# Nicely formatted date
alias datex='date +"%Y-%m-%d (%A) @ %H:%M:%S"'

# Start screen if not already running
#if [[ -z "$STY" ]] ; then
#	screen -RdU
#fi
alias scr='screen -RdU'
alias sc='screen'

############################################################
## Program specific functionality
############################################################

# Subversion shortcuts
function svnci {
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
function svnm {
	if [[ "$1" != "" ]]; then
		echo "$*" >> svn-commit.tmp
	else
		cat svn-commit.tmp
	fi
}
alias svnco='svn checkout'
function svndiff {
	svn diff $* | vim -R -
}
alias svnadd="svn add . --force"
alias svndel="svn status | sed -e '/^!/!d' -e 's/^! *//' | tr '\n' '\0' | xargs --null -i -t svn rm {}"

# Ruby on rails shortcuts
alias rgen='script/generate'
alias rdes='script/destroy'
alias rcon='script/console'
alias rplug='script/plugin'
alias rdbmig='rake db:migrate'
