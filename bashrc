# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Load config
for SCRIPT in ~/.doormat/bash/config/*
do
	if [ -x "${SCRIPT}" ]; then
		. ${SCRIPT}
	fi
done

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
