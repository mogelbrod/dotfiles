cd $HOME
set fish_config_path $HOME/.config/fish

# {{{ Function to reload configuration files
function rc
	echo "Reloading FISH configuration"
	. $fish_config_path/config.fish
end
# }}}

# Initialize prompt
. $fish_config_path/prompt

# Define functions
. $fish_config_path/functions

# Do not include home directory in cd alternatives
set -x CDPATH "."

# Disable the greeting and exit messages
set fish_greeting ""
#function fish_on_exit --on-process %self; exit; end

# {{{ Colors
# normal, black, white, red, green, blue, cyan, yellow (brown), magenta (purple)
# -b (background) -o (bold) -u (underline)
	set fish_color_command         green -o
	set fish_color_error           red
	set fish_color_comment         black -o

	set fish_color_cwd             yellow
	set fish_color_cwd_root        yellow

	set fish_color_normal          normal
	set fish_color_operator        blue -o
	set fish_color_quote           magenta -o
	set fish_color_valid_path      normal -o
	set fish_color_escape          blue

	set fish_color_history_current magenta
	set fish_color_redirection     normal

	set fish_color_match           black 
	set fish_color_search_match    black

	set fish_pager_color_completion  normal
	set fish_pager_color_description black -o
	set fish_pager_color_prefix      cyan -o
	set fish_pager_color_progress    blue

	# LS colors
	set -x LS_COLORS "no=00:fi=00:di=00;34:ln=01;36:pi=00;33:so=01;35:do=01;35:bd=00;33;01:cd=00;33;01:or=40;34;01:su=00;41:sg=00;43:tw=40;32:ow=40;32:st=37;44:ex=01;32:*.tar=01;33:*.tgz=01;33:*.gz=01;33:*.bz2=01;33:*.png=01;31:*.gif=01;31:*.jpg=01;31:*.jpeg=01;31:*.svg=01;31:*.bmp=01;31"
# }}}

# {{{ Title
function fish_title
	if test "$title" = ""
		echo $_ ' '; pwd
	else
		echo $title
	end
end
# }}}
