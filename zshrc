#{{{ Environment

  # Disable flow control
  stty -ixon -ixoff
  unsetopt flow_control flowcontrol

  # Add various directories to PATH
  export PATH=".:./node_modules/.bin"

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
  #zstyle :compinstall filename '/home/mogel/.zshrc'

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

  # Ctrl+left/right
  case "$OSTYPE" in
    darwin*)
      ;;
    linux*)
      bindkey "^[[D" backward-word # putty
      bindkey "^[[C" forward-word # putty
      ;;
  esac
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
#{{{ Environment specific (optional)

  [ -e "${HOME}/.iterm2_shell_integration.zsh" ] && . "${HOME}/.iterm2_shell_integration.zsh"
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#}}}

# Directory listing
if [[ "$OSTYPE" =~ "darwin[0-9.]*" ]]; then
  # OSX uses a different flag for colors
  alias ls='/bin/ls -b -CFG'
else
  alias ls='/bin/ls -b -CF --color=auto'
fi

alias -g M='| more'
alias -g L="| less"
alias -g G='| grep'

alias rc='source ~/.zshrc'

# Load .profile
[ -f "$HOME/.profile" ] && . "$HOME/.profile"
