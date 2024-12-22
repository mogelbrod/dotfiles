export DOTFILES_PROFILE_LOADED=1

export LC_ALL=en_US.UTF-8
export WORDCHARS="_-~"

export MANPAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""
export EDITOR=vim PAGER=less BROWSER=w3m

[ -n "$VSCODE_INJECTION" ] && command -v code &> /dev/null && export EDITOR="code --wait"

if [[ "$(uname -s)" == Darwin ]]; then
  export BROWSER=open
fi

# Add local bin dirs to path
if [ -d "$HOME/bin" ]; then
  export PATH="$HOME/bin:$PATH"
fi

#{{{ Aliases

  alias cls=clear
  alias quit=exit

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
  alias rmnodemodules='find . -name node_modules -type d -prune -exec rm -rf "{}" +'

  # cd which replaces substrings in PWD
  function scd {
    cd `echo $PWD | sed s/$1/$2/`
  }

  # print a single column from stin
  function column {
    awk "{print \$$1}"
  }

  # Nicely formatted date
  alias datex='date +"%Y-%m-%d (%A) @ %H:%M:%S"'

  alias psg='ps -A | grep'

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

  function port-kill {
    if [[ -z "$1" ]]; then
      echo "Provide a port number"
    else
      kill -9 $(lsof -t -sTCP:LISTEN -i:"$1")
    fi
  }

  function nodebug {
    NODE_OPTIONS="--inspect-brk" "$@"
  }

  # usage: sync-dirs ../capsule/dist/ node_modules/@soundtrackyourbrand/capsule/dist
  function sync-dirs {
    fswatch -o "$1" | while read f; do
      rsync -aci "$1" "$2" | grep '^>' | cut -c 11-
    done
  }

#}}}
#{{{ Git specific

  alias gs='git status'
  alias gpu='git pull'
  alias gp='git push'
  alias gpp='git pull && git push'
  alias gfo='git fetch origin'
  alias gco='git checkout'

  alias ga='git add --all'
  alias gap='git add --patch'
  alias gaundo='git rm --cached -r' # remove from index (keep in working dir)

  alias gr='git reset HEAD' # unstage files

  alias grm='git ls-files -d -z | xargs -0 git update-index --remove'  # remove missing files
  alias grm-merged='git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d'
  alias grm-stale='git remote prune origin'

  alias gc='git commit'
  alias gcm='git commit -m'
  alias gcundo='git reset --soft HEAD^' # undo commit

  alias gca='git commit --amend'
  alias gcf='git commit --fixup'

  alias gd='git diff -b'
  alias gds='git diff -b --staged'

  alias gl='git log --color --name-status --pretty=format:"%C(red)[%h] %an %C(blue)(%ar)%n%C(green)%s%n%b%C(reset)"'
  alias glt='git log --all --color --graph --pretty=format:"%C(red)[%h] %an %C(blue)(%ar)%C(green)%d%C(reset) %s"'

  # Interactive rebase against origin branch
  gras() {
    base="$1"
    [ -z "$base" ] && base=$(basename $(git symbolic-ref --short refs/remotes/origin/HEAD))
    git rebase -i --autosquash $base
  }

  # Outputs a markdown-like changelog starting from the specified ref (defaults to main branch)
  gcl() {
    base="$1"
    [ -z "$base" ] && base=$(basename $(git symbolic-ref --short refs/remotes/origin/HEAD))
    output=$(git log --reverse --pretty="≤ %s (%h)%+b" origin/$base.. | sed 's/^\([^≤]\)/  \1/; s/^\≤ /- /; /^$/d' | tee /dev/tty )
    if [[ $OSTYPE =~ "darwin[0-9.]*" ]]; then
      echo "$output" | pbcopy
    fi
  }

  # Outputs diff of a specific commit (defaults to most recent one)
  gdc() {
    commit="$1"
    [[ -z "$commit" ]] && commit="HEAD" || shift
    git diff --diff-algorithm minimal $commit^ $commit $*
  }

  # Outputs a link to the given ref on GitHub
  gcremote() {
    cmd="echo"
    case "$1" in
      open|browser|copy|pbcopy)
        cmd="$1"
        shift
        ;;
    esac
    ref=$(git rev-parse ${1:-HEAD})
    origin=$(git config --get remote.origin.url | sed -E 's/^git@//; s/\.git$//; s/:/\//g; s#^((git|git+ssh|https?)://)?#https://#')
    url="$origin/commit/$ref"
    case "$cmd" in
      open|browser)
        open "$url"
        ;;
      copy|pbcopy)
        echo "$url" | pbcopy
        ;;
    esac
    echo "$url"
  }

  gprc() {
    ref=$(git rev-parse ${1:-HEAD})
    refsubject=$(git log -1 --pretty=format:"%s" "$ref")
    branch="$2"
    [ -z "$branch" ] && branch="$refsubject"
    branch=$(echo "$branch" \
      | sed -r 's#(\(([^):]+)\))?!?:#/\2#' \
      | iconv -t ascii//TRANSLIT \
      | sed -r 's/[^a-zA-Z0-9/_-]+/-/g' \
      | sed -r 's/^-+\|-+$//g' | tr A-Z a-z
    )
    echo "Commit: $ref"
    echo "Title:  $refsubject"
    echo
    vared -p "Branch: " branch
    base=$(git symbolic-ref --short refs/remotes/origin/HEAD)
    upstream=$(dirname $base)
    read -r -d '' GITCOMMANDS <<EOF
    git fetch $upstream
    git checkout -b $branch $base
    git cherry-pick $ref
    gh pr create
EOF
    sh -e -c "$GITCOMMANDS" || echo -e "PR creation failed - commands that would've been run:\n$GITCOMMANDS"
  }

  gcleanup() {
    base=$(basename $(git symbolic-ref --short refs/remotes/origin/HEAD))
    git fetch origin --prune
    git branch --merged | egrep -v "(^\*|$base|dev)" | xargs git branch -d; git remote prune origin
  }

  gunmerged() {
    git log "$1" ^master --no-merges
  }

  gbump() {
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

    # Make Ctrl-] copy current input to system clipboard
    pbcopy-whole-line() {
      echo -n $BUFFER | pbcopy
    }; zle -N pbcopy-whole-line
    bindkey '^]' pbcopy-whole-line
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
  fi

#}}}

# Load local .profile
[ -f "$HOME/.profile.local" ] && . "$HOME/.profile.local"
