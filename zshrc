#{{{ Environment

  export LC_ALL=en_US.UTF-8

  export EDITOR=vim PAGER=less BROWSER=w3m
  export WORDCHARS="_-~"

  # Disable flow control
  stty -ixon -ixoff
  unsetopt flow_control

  # Add user bin to PATH
  if [ -d "$HOME/bin" ] ; then
      export PATH="$HOME/bin:$PATH"
  fi

  # Add current directory to PATH
  export PATH=.:$PATH

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
  #zstyle ':completion:*' list-colors ''
  #zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
  zmodload zsh/complist

#}}}
#{{{ Prompt

  setopt prompt_subst

  precmd() {
    # Title
    if [[ $TERM == (*xterm*|rxvt); ]]; then
      print -Pn "]0;[%n@%m] %~\a"
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
    local user_color=$PR_BRIGHT_BLUE
    [[ "$USER" == "root" ]] && user_color=$PR_BRIGHT_RED
    local host_color=$PR_CYAN
    case $HOST in
      mogelserv) host_color=$PR_BRIGHT_BLUE ;;
      hallberg)  host_color=$PR_GREEN ;;
    esac

    local user_host="${faded}[${PR_RESET}${user_color}%n${faded}@${PR_RESET}${host_color}%m${faded}:%l]"
    local padded_cwd="${PR_RESET}${PR_YELLOW}%$pwdsize<...<%~%<<${(r:$pwdpad:: :::)}"
    local now="${faded}[%D{%H:%M:%S}]${PR_RESET}"
    local error_num="%(?::${faded}[${PR_BRIGHT_RED}%?${PR_RESET}${faded}]${PR_RESET} )"
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

  # Ignore uninteresting users
  zstyle ':completion:*:*:*:users' ignored-patterns \
    apache backup bin daemon dbus ftp games gnats irc landscape libuuid list lp \
    mail man messagebus mysql news ntop ntp proxy sshd sync sys syslog uucp whoopsie

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
  bindkey "^[OA" history-search-backward
  bindkey "^[0B" history-search-forward
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
  alias ls='/bin/ls -b -CF --color=auto'
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

  # cd which replaces substrings in PWD
  function scd { cd `echo $PWD | sed s/$1/$2/` }

  # Nicely formatted date
  alias datex='date +"%Y-%m-%d (%A) @ %H:%M:%S"'

  alias psg='ps -A | grep'

  # Global aliases
  alias -g M='| more'
  alias -g L="| less"
  alias -g G='| grep'

  # Other useful aliases
  alias rails_routes='rake routes | vim - -c ":set nowrap buftype=nofile"'
  alias tags='ctags -f .tags --exclude=.git --exclude=log -R .'

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
#{{{ File associations

  alias -s tex=$EDITOR txt=$EDITOR css=$EDITOR js=$EDITOR conf=$EDITOR
  alias -s htm=$BROWSER html=$BROWSER

#}}}
#{{{ Platform specific

  if [ "$TERM" = "cygwin" ] ; then
    vim() { # use graphical vim
      `D:\\\Programs\\\vim\\\vim73\\\gvim.exe $*` & 
    }
  fi

  linux_platform=`lsb_release -s -i`

  if [ "$linux_platform" = "Ubuntu" ] ; then
    alias o='gnome-open'
  fi

#}}}
