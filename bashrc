#{{{ Environment

  # Fix readline input
  export INPUTRC=~/.inputrc

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

#}}}

alias rc='source ~/.bashrc'

# Load .profile
[ -f "$HOME/.profile" ] && . "$HOME/.profile"
