# Function to reload configuration files
function reload
	echo "Reloading FISH configuration."
	. $HOME/.config/fish/config.fish
end

# Initialize prompt
. $HOME/.config/fish/prompt

# Define functions
. $HOME/.config/fish/functions

# Disable the greeting and exit messages
set fish_greeting ""
# function fish_on_exit --on-process %self; exit; end

set -x CDPATH "."

# {{{ Key bindings
function custom_key_bindings
	fish_default_key_bindings

	# Word movement
	bind "[1;5D" backward-word
	bind "[1;5C" forward-word
	bind "[3;3~" kill-word

	# Other bindings
	bind \cd kill-whole-line

end
set fish_key_bindings custom_key_bindings
# }}}

# {{{ Colors
# normal, black, white, red, green, blue, cyan, yellow (brown), magenta (purple)
# -b (background) -o (bold) -u (underline)
	set fish_color_command         green -o
	set fish_color_error           red
	set fish_color_comment         black -o

	set fish_color_cwd             yellow
	set fish_color_cwd_root        brown

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
