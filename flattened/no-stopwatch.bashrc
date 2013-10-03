#
# Flattened Doormat Configuration
# Generated: 2013-10-03 07:26:04
# Version: v0.1-23-g9369f36
#
# Configuration
# Edit/add configuration/customizatinos hereto enable/disable functionality
#

if [ -z "$DOORMAT_CONFIG" ]
then
# File: config/10-colors
# Configure colors (when enabled)
DOORMAT_COLOR_AT='[0;32m' # light green
DOORMAT_COLOR_DOMAIN='[0;32m' # light green
DOORMAT_COLOR_COMMAND_NUMBER='[1;35m' # purple
DOORMAT_COLOR_CWD='[1;34m' # blue
DOORMAT_COLOR_INPUT='[0m' # reset color for input
DOORMAT_COLOR_HISTORY_NUMBER='[1;35m' # purple
DOORMAT_COLOR_HOSTNAME='[1;32m' # bold green
DOORMAT_COLOR_PROMPT_SUCCESS='[1;32m' # bold green
DOORMAT_COLOR_PROMPT_ERROR='[1;31m' # bold red
DOORMAT_COLOR_PROMPT='[0m' # bold red
DOORMAT_COLOR_STOPWATCH='[1;33m' # yellow
DOORMAT_COLOR_USER='[1;32m' # bold green


# File: config/10-modules
DOORMAT_COLORS="1"
DOORMAT_STATUS_COLOR="1"
DOORMAT_FQDN="1"
DOORMAT_STOPWATCH=0
DOORMAT_TITLE="1"
DOORMAT_LOCAL="1"

# File: config/10-ps1
# Configure primary prompt (PS1)
DOORMAT_PS1='$PS1_stopwatch \u@\h \w \$ '

# File: config/40-cygwin
# cygwin doesn't have the option to get FQDN
if [[ "$OSTYPE" == 'cygwin' ]]
then
	DOORMAT_FQDN="0"
fi

# File: config/50-root
if [[ $EUID -eq 0 ]]
then
	DOORMAT_PS1='$PS1_stopwatch \h \W \$ '
	DOORMAT_COLOR_AT='[0;31m' # light red
	DOORMAT_COLOR_HOSTNAME='[1;31m' # bold red
	DOORMAT_COLOR_DOMAIN='[0;31m' # light red
fi

fi
DOORMAT_CONFIG="1"

#
# Aliases
# Common/Useful Aliases not defined by functionality
#


#
# Init Scripts
# Responsible for providing functionality
#

# File: init/05-detect-colors
# If enable, see if the terminal supports colors
if [[ $DOORMAT_COLORS -eq 1 ]];
then
	safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
	match_lhs=""
	if [[ -f ~/.dir_colors ]]
	then
		match_lhs="${match_lhs}$(<~/.dir_colors)"
	fi

	if [[ -f /etc/DIR_COLORS ]]
	then
		match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
	fi

	if [[ -z ${match_lhs} ]]
	then
		type -P dircolors > /dev/null 
		if [ $? -eq 0 ]
		then
			match_lhs=$(dircolors --print-database)
		fi
	fi

	if [[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]]
	then
		use_color=true
	fi

	if [[ ! $use_color ]]
	then
		COLORS="$(tput colors 2> /dev/null)"
		if [[ $? -eq 0 && $COLORS -gt 2 ]]
		then
			use_color=true
		fi
		unset COLORS
	fi

	if [[ ! $use_color ]]
	then
		DOORMAT_COLORS="0"
	fi

	unset safe_term match_lhs use_color
fi
# File: init/05-prompt-base
# Set PS1 if it isn't already set by configuration
if [[ -z $DOORMAT_PS1 ]]
then
	if [[ ${EUID} == 0 ]]
	then
		PS1='$PS1_stopwatch \h \W \$ '
	else
		PS1='$PS1_stopwatch \u@\h \w \$ '
	fi
else
	PS1=$DOORMAT_PS1
fi
# File: init/05-prompt-command
# Reset PROMPT_COMMAND
PROMPT_COMMAND="ps1_return=\$?;"
# File: init/10-bash-completion
# If there's a bash-completion configuration, load it
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    # Bash completions can take a long time to load
    # Some distributions (like ubuntu), may load them automatically
    # Only load if BASH_COMPLETION_COMPAT_DIR is not set
    if [ ! $BASH_COMPLETION_COMPAT_DIR ]
    then
        . /etc/bash_completion
    fi
fi
# File: init/10-fqdn
# if FQDN is enabled, replace \h with FQDN (customizable by colors)
if [ $DOORMAT_FQDN -eq 1 ]
then

    doormat_hostname_load()
    {
		local hostname_cmd="hostname"
		local has_timeout=0
		
		# Use timeout command if it exists
		type timeout > /dev/null 2>&1
		if [ $? -eq 0 ]
		then
            hostname_cmd="timeout 1 hostname"
            has_timeout=1
        fi

		# Attempt to retrieve the FQDN hostname
		# check error code, then see if its empty,
        PS1_fqdn=$($hostname_cmd -f 2> /dev/null)
        local cmd_status=$?
        # Check for error, report if needed
        if [ ! $cmd_status -eq 0 ]
        then
			if [ $cmd_status -eq 124 ] && [ $has_timeout -eq 1 ]
			then
				echo "Warning: Hostname lookup timed out!"
            fi
		fi
		
		# If the FQDN is still empty, settle for non-fqdn hostname
		if [ -z $PS1_fqdn ]
		then
			PS1_fqdn=$($hostname_cmd 2> /dev/null)
		fi
    }
    doormat_hostname_load
fi
# File: init/10-history
# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace
HISTTIMEFORMAT="%F %T  "

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTFILESIZE=100000
HISTSIZE=100000

PROMPT_COMMAND="$PROMPT_COMMAND history -a;"

# File: init/10-lesspipe
# make less more friendly for non-text input files, see lesspipe(1)
if [ -x /usr/bin/lesspipe ];
then
	export LESSOPEN="|lesspipe %s"
fi
# File: init/10-window-size
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# File: init/30-colors-setup
# Enable colors for commands like ls and grep
if [[ $DOORMAT_COLORS -eq 1 ]]
then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	# Defina aliases if dircolors exists
	if [ -x /usr/bin/dircolors ]
	then
		test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
		alias ls='ls --color=auto'
		alias dir='dir --color=auto'
		alias vdir='vdir --color=auto'

		# Test to see if grep supports the color option
		echo test | grep test --color > /dev/null 2>&1

		# Set the alias if there's no error
		if [ $? -eq 0 ]
		then
			alias grep='grep --color=auto'
			alias fgrep='fgrep --color=auto'
			alias egrep='egrep --color=auto'
		fi
	fi

	# If on MAC, enable the colosr on the terminal and dfeine LSCOLORS
	if [[ $OSTYPE == darwin* ]];
	then
	        export CLICOLOR=1
	        export LSCOLORS=GxFxCxDxBxegedabagaced
	fi
fi
# File: init/30-local
if [[ $DOORMAT_LOCAL -eq 1 ]];
then
	# If a .local/bin exists, use it in $PATH
	if [ -d "$HOME/.local/bin" ];
	then
		PATH="$HOME/.local/bin:$PATH"
	fi

	# If an autocomplete directory exists, use it
	if [ -d "$HOME/.local/etc/bash_completion.d" ];
	then
		for SCRIPT in $HOME/.local/etc/bash_completion.d/* 
		do
			if [ -x "${SCRIPT}" ]; then
				. ${SCRIPT}
			fi
		done
	fi
fi
# File: init/30-prompt-fqdn
# if FQDN is enabled, replace \h with FQDN (customizable by colors)
if [[ $DOORMAT_FQDN -eq 1 ]]
then
	PS1=${PS1/\\h/\\h$\{PS1_fqdn\#\#\\h\}}
fi
# File: init/30-shell-title
# Change the window title of X terminals 
if [[ $DOORMAT_TITLE -eq 1 ]]
then
	if [ $DOORMAT_FQDN -eq 1 ]
	then
		prompt_title_xterm()
		{
			echo -ne "\033]0;${USER}@${PS1_fqdn}:${PWD/$HOME/~}\007"
		}

		prompt_title_screen()
		{
			echo -ne "\033_${USER}@${PS1_fqdn}:${PWD/$HOME/~}\033\\"
		}
	else
		prompt_title_xterm()
		{
			echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"
		}

		prompt_title_screen()
		{
			echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"
		}
	fi
	PROMPT_TITLE=""
	case ${TERM} in
		xterm*|rxvt*|Eterm|aterm|kterm|gnome*|interix)
			PROMPT_TITLE="prompt_title_xterm;"
			;;
		screen)
			PROMPT_TITLE="prompt_title_screen;"
		;;
	esac

	if [[ ! -z $PROMPT_TITLE ]]
	then
		PROMPT_COMMAND="$PROMPT_COMMAND $PROMPT_TITLE"
	fi
fi
# File: init/50-prompt-color
# If colors are enabled, do replacement to user-configured colors
if [[ $DOORMAT_COLORS -eq 1 ]]
then
	# @ sign (usually user@hostname)
	if [[ ! -z $DOORMAT_COLOR_AT ]]
	then
		PS1=${PS1/@/\\\[\\e${DOORMAT_COLOR_AT}\\\]@}
	fi

	# username
	if [[ ! -z $DOORMAT_COLOR_USER ]]
	then
		PS1=${PS1/\\u/\\\[\\e${DOORMAT_COLOR_USER}\\\]\\u}
	fi

	# hostname
	if [[ ! -z $DOORMAT_COLOR_HOSTNAME ]]
	then
		PS1=${PS1/\\h/\\\[\\e${DOORMAT_COLOR_HOSTNAME}\\\]\\h}
	fi

	if [[ $DOORMAT_FQDN -eq 1 ]]
	then
		PS1=${PS1/\\h$\{PS1_fqdn##\\h\}/\\h\\\[\\e${DOORMAT_COLOR_DOMAIN}\\\]\$\{PS1_fqdn##\\h\}}
	fi

	# working directory
	if [[ ! -z $DOORMAT_COLOR_CWD ]]
	then
		PS1=${PS1/\\w/\\\[\\e${DOORMAT_COLOR_CWD}\\\]\\w}
		PS1=${PS1/\\W/\\\[\\e${DOORMAT_COLOR_CWD}\\\]\\W}
	fi

	# shell symbol
	if [[ ! -z $DOORMAT_COLOR_PROMPT ]]
	then
		PS1=${PS1/\\\$/\\\[\\e${DOORMAT_COLOR_PROMPT}\\\]\\\$}
	fi

	# history number
	if [[ ! -z $DOORMAT_COLOR_COMMAND_NUMBER ]]
	then
		PS1=${PS1/\\\#/\\\[\\e${DOORMAT_COLOR_COMMAND_NUMBER}\\\]\\\#}
	fi

	# history number
	if [[ ! -z $DOORMAT_COLOR_HISTORY_NUMBER ]]
	then
		PS1=${PS1/\\\!/\\\[\\e${DOORMAT_COLOR_HISTORY_NUMBER}\\\]\\\!}
	fi

	# stopwatch
	if [[ ! -z $DOORMAT_COLOR_STOPWATCH ]]
	then
		PS1=${PS1/\$PS1_stopwatch/\\\[\\e${DOORMAT_COLOR_STOPWATCH}\\\]\$PS1_stopwatch}
		PS1=${PS1/\$\{PS1_stopwatch\}/\\\[\\e${DOORMAT_COLOR_STOPWATCH}\\\]\$\{PS1_stopwatch\}}
	fi
	
	# Show green $ when status enabled
	if [[ $DOORMAT_STATUS_COLOR -eq 1 && ! -z $DOORMAT_COLOR_PROMPT_SUCCESS && ! -z $DOORMAT_COLOR_PROMPT_ERROR ]]
	then
		ps1_status_color()
		{
			if [[ $ps1_return -eq 0 ]]
			then
				PS1_status_color="$DOORMAT_COLOR_PROMPT_SUCCESS"
				PS1_status_text=""
			else
				PS1_status_color="$DOORMAT_COLOR_PROMPT_ERROR"
				PS1_status_text="$ps1_return "
			fi
		}

		PROMPT_COMMAND="$PROMPT_COMMAND ps1_status_color;"

		# move prompt color (if needed)
		PS1=${PS1/\\\[\\e$DOORMAT_COLOR_PROMPT\\\]\\\$/\\\$\\\[\\e$DOORMAT_COLOR_PROMPT\\\]}

		# Replace \$ with [color]\$
		PS1=${PS1/\\\$/\\\[\\e\$PS1_status_color\\\]\$PS1_status_text\\\$}
	fi
fi
# File: init/80-prompt-stopwatch
# Check for basic compatibility (date command must support nanoseconds)
# BSD versions (like on a Mac) do not support this
if [[ "$(date +%N)" == 'N' ]]
then
	DOORMAT_STOPWATCH="0"
fi

# Time how long eat command takes to run
if [[ $DOORMAT_STOPWATCH -eq 1 ]]
then
	ps1_stopwatch_start()
	{
		if [ -z "$ps1_stopwatch_start_time" ]
		then
			ps1_stopwatch_start_time="$(date +"%s %N")"
		fi
	}

	ps1_stopwatch_calculate()
	{
		# Read the last set time
		read begin_s begin_ns <<< "$ps1_stopwatch_start_time"

		# PENDING - date takes about 11ms
		# Perhaps could do better by digging in /proc/$$.  
		read end_s end_ns <<< $(date +"%s %N")

		# The nanoseconds sometimes come up with a leading 0
		# which makes bash thinks its in base-10
		# convert these numbers for bash
		begin_ns=$((10#${begin_ns}))
		end_ns=$((10#${end_ns}))

		local s=$((end_s - begin_s))
		local ms
		if [ $end_ns -ge $begin_ns ]
		then
			ms=$(((end_ns - begin_ns) / 1000000))
		else
			s=$((s - 1))
			ms=$(((1000000000 + end_ns - begin_ns) / 1000000))
		fi
		PS1_stopwatch="$(printf "%u.%03u" $s $ms)"
		if [ "$s" -ge 60 ]
		then
			PS1_stopwatch="$PS1_stopwatch [$(ps1_stopwatch_format $s)]"
		fi
	}

	ps1_stopwatch_format()
	{
		local s=$1
		local days=$((s / (60*60*24)))
		s=$((s - days*60*60*24))
		local hours=$((s / (60*60)))
		s=$((s - hours*60*60))
		local min=$((s / 60))
		if [ "$days" != 0 ]
		then
			local day_string="${days}d "
		fi
		printf "$day_string%02d:%02d\n" $hours $min
	}  

	ps1_stopwatch_stop()
	{
		status=$?
		local size=16
		ps1_stopwatch_calculate
		ps1_stopwatch_start_time=
	}

	ps1_stopwatch_start

	trap ps1_stopwatch_start DEBUG
	
	PROMPT_COMMAND="$PROMPT_COMMAND ps1_stopwatch_stop; "
else
	PS1=${PS1/\$PS1_stopwatch /}
	PS1=${PS1/\$\{PS1_stopwatch\} /}
fi
