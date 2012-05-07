# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Only load configuration once
# Allow configuration to be updated and sourced
if [ -z "$DOORMAT_CONFIG" ]
then
	# Load config
	for SCRIPT in ~/.doormat/bash/config/*
	do
		if [ -x "${SCRIPT}" ]; then
			. ${SCRIPT}
		fi
	done
fi

# Set the configuration as loaded so we don't load it again
# This allows the user to set variables and resource the script
# for temporary configuration changes
DOORMAT_CONFIG="1"

for SCRIPT in ~/.doormat/bash/aliases/*
do
	if [ -x "${SCRIPT}" ]; then
		. ${SCRIPT}
	fi
done

# Load scripts
for SCRIPT in ~/.doormat/bash/init/*
do
	if [ -x "${SCRIPT}" ]; then
		. ${SCRIPT}
	fi
done
