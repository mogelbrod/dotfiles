#{{{ Environment

  export LC_ALL=en_US.UTF-8
  export WORDCHARS="_-~"

  export EDITOR=vim PAGER=less BROWSER=w3m
  export MANPAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""

  # Disable flow control
  stty -ixon -ixoff
  unsetopt flow_control flowcontrol

  # Add various directories to PATH
  export PATH=".:./node_modules/.bin:$HOME/bin:$PATH"

  # Auto push dir when CDing
  setopt auto_pushd pushd_silent pushd_ignore_dups

  unset nomatch # error when filename patterns does not match anything

  # Allow short styled loops: for i (*.c) echo $i
  set short_loops

  # Beeping/bell
  unsetopt hist_beep list_beep beep

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
  export LSCOLORS=exfxcxdxbxegedabagcaea
  #zstyle ':completion:*' list-colors ''
  #zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
  zmodload zsh/complist

#}}}
#{{{ Prompt

  setopt prompt_subst

  git_prompt_info() {
    [[ $(git symbolic-ref HEAD 2>&1) =~ "fatal: " ]] && return
    if [[ $(git branch) =~ "\* ([a-z0-9._/-]+)" ]]; then
      echo " (${match[1]})"
    else
      echo " (:$(git rev-parse --short HEAD))"
    fi
  }

  precmd() {
    # Terminal title (overriden by $TERM_TITLE env)
    if [[ $TERM == (*xterm*|rxvt) ]]; then
      title=$TERM_TITLE
      [[ -z $TERM_TITLE ]] && title="%~"
      print -Pn "]0;$title\a"
    fi

    # Git info
    local git_info="$(git_prompt_info)"

    local termwidth; (( termwidth = ${COLUMNS} - 1 ))
    local promptlen=${#${(%):-[%n@%m]${git_info} [%D{%H:%M:%S}]}}
    local pwdlen=${#${(%):-%~}}
    local pwdsize; (( pwdsize = $termwidth - $promptlen))
    local pwdpad=0; (( pwdpad = $pwdsize - $pwdlen))
    if [[ $pwdpad -lt 0 ]]; then
      pwdpad=0;
    fi

    local faded="${PR_BRIGHT_BLACK}"

    # User / host colorization
    local user_color=$PR_BRIGHT_BLUE
    [[ "$USER" == "root" ]] && user_color=$PR_BRIGHT_RED
    local host_color=$PR_CYAN
    case $HOST in
      mogelserv) host_color=$PR_BRIGHT_BLUE ;;
      hallberg)  host_color=$PR_GREEN ;;
    esac

    local user_host="${faded}[${PR_RESET}${user_color}%n${faded}@${PR_RESET}${host_color}%m${faded}]"
    local padded_cwd="${PR_RESET}${PR_YELLOW}%$pwdsize<...<%~%<<${(r:$pwdpad:: :::)}"
    local now="${faded}[%D{%H:%M:%S}]${PR_RESET}"
    local error_num="%(?::${faded}[${PR_BRIGHT_RED}%?${PR_RESET}${faded}]${PR_RESET} )"
    local pr="${PR_BLUE}%(!.#.$) ${PR_RESET}"

    print -rP "${user_host}${PR_GREEN}${git_info} ${padded_cwd} ${now}"
    PROMPT="${error_num}${pr}"
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

  setopt complete_in_word always_to_end
  setopt auto_param_slash auto_param_keys auto_list

  # Ignore uninteresting users
  zstyle ':completion:*:*:*:users' ignored-patterns \
    apache backup bin daemon dbus ftp games gnats irc landscape libuuid list lp \
    mail man messagebus mysql news ntop ntp proxy sshd sync sys syslog uucp whoopsie

#}}}
#{{{ History

  HISTFILE=~/.histfile
  HISTSIZE=5000
  SAVEHIST=1000
  setopt append_history incappendhistory hist_reduce_blanks

#}}}
#{{{ Bindings

  bindkey -e
  bindkey ' ' magic-space

  # Up/down scrolls through history (search if possible)
  bindkey "^[OA" history-search-backward
  bindkey "^[OB" history-search-forward
  # Putty up/down
  bindkey "^[[A" history-search-backward
  bindkey "^[[B" history-search-forward

  # Word moving
  # Putty Ctrl-left/right
  bindkey "^[0D" backward-word
  bindkey "^[0C" forward-word
  # Ctrl+left/right
  bindkey "^[[1;5D" backward-word 
  bindkey "^[[1;5C" forward-word
  # Alt+left/right
  bindkey "^[[1;3D" backward-word
  bindkey "^[[1;3C" forward-word

  # Word deletion
  bindkey "^[[3;5~" kill-word # Ctrl-Delete

  # Page up/down
  bindkey "^[[5~" backward-word
  bindkey "^[[6~" forward-word

  # Ctrl-D clears line
  bindkey "\C-d" kill-whole-line

  # Ctrl-P opens previous line but deletes command
  replace_last_command() { zle up-history; zle beginning-of-line; zle kill-word }
  zle -N replace-last-command replace_last_command
  bindkey "^P" replace-last-command

  # Ctrl-S/Alt-S inserts sudo at beginning of line
  insert_sudo () { zle beginning-of-line; zle -U "sudo " }
  zle -N insert-sudo insert_sudo
  bindkey "^[s" insert-sudo
  bindkey "^S" insert-sudo

#}}}
#{{{ Aliases

  alias rc='source ~/.zshrc'

  alias cls=clear
  alias quit=exit

  # Directory listing
  if [[ "$OSTYPE" =~ "darwin[0-9.]*" ]] ; then
    # OSX uses a different flag for colors
    alias ls='/bin/ls -b -CFG'
  else
    alias ls='/bin/ls -b -CF --color=auto'
  fi

  alias la='ls -a'
  alias l='ls -lh'
  alias ll='ls -lha'
  alias lg='ls -lha | grep'

  # Shortcuts
  alias ..='cd ..'
  alias e=$EDITOR
  alias vi='vim'
  alias un='tar -xf'
  alias sc='screen'
  alias scr='screen -RdU'
  alias du='du -hs'

  alias rmorig='find . -name "*.orig" -delete'

  # cd which replaces substrings in PWD
  function scd { cd `echo $PWD | sed s/$1/$2/` }

  # print a single column from stin
  function column { awk "{print \$$1}" }

  # Nicely formatted date
  alias datex='date +"%Y-%m-%d (%A) @ %H:%M:%S"'

  alias psg='ps -A | grep'

  # Global aliases
  alias -g M='| more'
  alias -g L="| less"
  alias -g G='| grep'

  # Other useful aliases
  alias vims='vim - -c ":set nowrap buftype=nofile"'

  function tags {
    ctags -f .tags --exclude=.git ${1:+--languages=$1} -R .
  }

  # Use BC to calculate stuff
  function c {
    echo "scale=6; $*" | bc
  }

  function largest_files {
    find ${*:-.} -ls | awk '{printf "%12s %s \n", $7, $11}' | sort
  }

  function title {
    TERM_TITLE="$*"
    [[ -z "$TERM_TITLE" ]] && TERM_TITLE=$(basename `pwd`)
  }
  
  # Credits to http://dotfiles.org/~pseup/.bashrc
  function extract {
  	if [ -f $1 ] ; then
  		case $1 in
  			*.tar.bz2) tar xjf $1 ;;
  			*.tar.gz) tar xzf $1 ;;
  			*.bz2) bunzip2 $1 ;;
  			*.rar) rar x $1 ;;
  			*.gz) gunzip $1 ;;
  			*.tar) tar xf $1 ;;
  			*.tbz2) tar xjf $1 ;;
  			*.tgz) tar xzf $1 ;;
  			*.zip) unzip $1 ;;
  			*.Z) uncompress $1 ;;
  			*.7z) 7z x $1 ;;
  			*) echo "'$1' cannot be extracted via extract()" ;;
  		esac
  	else
  		echo "'$1' is not a valid file"
  	fi
  }

  function findn {
    find ${2:=.} -name $1
  }

  function findext {
    find ${2:=.} -type f -name "*.${1:=*}"
  }

  function agext {
    ext="$1"
    shift
    ag -G "\\.$ext$" $*
  }

  function port-usage {
    [[ -z $1 ]] || 1=":$1"
    lsof -nPi4TCP | grep "$1 (LISTEN)"
  }

#}}}
#{{{ Git specific

  alias gs='git status'
  alias gl='git pull'
  alias gp='git push'
  alias gpp='git pull && git push'
  alias gco='git checkout'

  alias ga='git add --all'
  alias gap='git add --patch'
  alias gaundo='git rm --cached -r' # remove from index (keep in working dir)

  alias gr='git reset HEAD' # unstage files

  alias grm='git ls-files -d -z | xargs -0 git update-index --remove'  # remove missing files
  alias grm-merged='git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d'

  alias gc='git commit'
  alias gcm='git commit -m'
  alias gcundo='git reset --soft HEAD^' # undo commit

  alias gca='git commit --amend'
  alias gcf='git commit --fixup'
  alias gras='git rebase -i --autosquash'

  alias gd='git diff --color -b'
  alias gds='git diff --color -b --staged'

  alias gl='git log --color --name-status --pretty=format:"%C(red)[%h] %an %C(blue)(%ar)%n%C(green)%s%n%b%C(reset)"'
  alias glt='git log --all --color --graph --pretty=format:"%C(red)[%h] %an %C(blue)(%ar)%C(green)%d%C(reset) %s"'

  function gdc() {
    commit="$1"
    [[ -z $1 ]] && commit="HEAD" || shift
    git diff --diff-algorithm minimal $commit^ $commit $*
  }

  function gbump() {
    what=${1:-patch}
    echo "Bumping $what version and pushing to origin"
    changed=$(git diff-index --name-only HEAD --)
    [ -n "$changed" ] && git stash
    git pull --rebase && npm version $what && git push && git push --tags
    [ -n "$changed" ] && git stash pop
    true
  }

#}}}
#{{{ Platform specific

  if [ "$TERM" = "cygwin" ] ; then
    vim() { # use graphical vim
      `D:\\\Programs\\\vim\\\vim73\\\gvim.exe $*` & 
    }
  fi

  which lsb_release &>/dev/null
  if [[ $? == 0 && `lsb_release -s -i` == "Ubuntu" ]] ; then
    # Ubuntu
    alias o='gnome-open'
  elif [[ $OSTYPE =~ "darwin[0-9.]*" ]] ; then
    # Mac OSX
    alias o='open'
    alias r='rmtrash'
  fi

  if [ -n "$ITERM_PROFILE" ] ; then
    alias tcdef='echo -e "\033]6;1;bg;*;default\a"'
    alias tcred='echo -en "\033]6;1;bg;red;brightness;249N^G\a" && echo -en "\033]6;1;bg;green;brightness;108N^G\a" && echo -en "\033]6;1;bg;blue;brightness;108N^G\a"'
    alias tcorange='echo -en "\033]6;1;bg;red;brightness;244N^G\a" && echo -en "\033]6;1;bg;green;brightness;171N^G\a" && echo -en "\033]6;1;bg;blue;brightness;81N^G\a"'
    alias tcyellow='echo -en "\033]6;1;bg;red;brightness;239N^G\a" && echo -en "\033]6;1;bg;green;brightness;219N^G\a" && echo -en "\033]6;1;bg;blue;brightness;91N^G\a"'
    alias tcgreen='echo -en "\033]6;1;bg;red;brightness;180N^G\a" && echo -en "\033]6;1;bg;green;brightness;210N^G\a" && echo -en "\033]6;1;bg;blue;brightness;80N^G\a"'
    alias tccyan='echo -en "\033]6;1;bg;red;brightness;128N^G\a" && echo -en "\033]6;1;bg;green;brightness;255N^G\a" && echo -en "\033]6;1;bg;blue;brightness;255N^G\a"'
    alias tcblue='echo -en "\033]6;1;bg;red;brightness;98N^G\a" && echo -en "\033]6;1;bg;green;brightness;165N^G\a" && echo -en "\033]6;1;bg;blue;brightness;245N^G\a"'
    alias tcmagenta='echo -en "\033]6;1;bg;red;brightness;255N^G\a" && echo -en "\033]6;1;bg;green;brightness;128N^G\a" && echo -en "\033]6;1;bg;blue;brightness;255N^G\a"'
    alias tcpurple='echo -en "\033]6;1;bg;red;brightness;192N^G\a" && echo -en "\033]6;1;bg;green;brightness;144N^G\a" && echo -en "\033]6;1;bg;blue;brightness;215N^G\a"'
    alias tcwhite='echo -en "\033]6;1;bg;red;brightness;255N^G\a" && echo -en "\033]6;1;bg;green;brightness;255N^G\a" && echo -en "\033]6;1;bg;blue;brightness;255N^G\a"'
    alias tcgray='echo -en "\033]6;1;bg;red;brightness;120N^G\a" && echo -en "\033]6;1;bg;green;brightness;120N^G\a" && echo -en "\033]6;1;bg;blue;brightness;120N^G\a"'
    alias tclgray='echo -en "\033]6;1;bg;red;brightness;192N^G\a" && echo -en "\033]6;1;bg;green;brightness;192N^G\a" && echo -en "\033]6;1;bg;blue;brightness;192N^G\a"'
    alias tcdgray='echo -en "\033]6;1;bg;red;brightness;64N^G\a" && echo -en "\033]6;1;bg;green;brightness;64N^G\a" && echo -en "\033]6;1;bg;blue;brightness;64N^G\a"'

    # Make Ctrl-] copy current input to system clipboard
    pbcopy-whole-line() {
      echo -n $BUFFER | pbcopy
    }; zle -N pbcopy-whole-line
    bindkey '^]' pbcopy-whole-line
  fi

#}}}

# Load local .profile
[ -f "$HOME/.profile.local" ] && . "$HOME/.profile.local"

[ -e "${HOME}/.iterm2_shell_integration.zsh" ] && . "${HOME}/.iterm2_shell_integration.zsh"
