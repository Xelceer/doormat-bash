#!/bin/sh

echo '#'
echo '# Flattened Doormat Configuration'
echo "# Generated: $(date +%Y-%m-%d\ %H:%M:%S)"
echo "# Version: $(git describe)"
echo '#'
echo '# Configuration'
echo '# Edit/add configuration/customizatinos hereto enable/disable functionality'
echo '#'
echo

# Load config
for SCRIPT in ~/.doormat/bash/config/*
do
	if [ -x "${SCRIPT}" ]; then
		echo "# File: ${SCRIPT}"
		cat ${SCRIPT}
		echo ""
	fi
done

echo
echo '#'
echo '# Aliases'
echo '# Common/Useful Aliases not defined by functionality'
echo '#'
echo

for SCRIPT in ~/.doormat/bash/aliases/*
do
	if [ -x "${SCRIPT}" ]; then
		echo "# File: ${SCRIPT}"
		cat ${SCRIPT}
	fi
done

echo
echo '#'
echo '# Init Scripts'
echo '# Responsible for providing functionality'
echo '#'
echo

# Load scripts
for SCRIPT in ~/.doormat/bash/init/*
do
	if [ -x "${SCRIPT}" ]; then
		echo "# File: ${SCRIPT}"
		cat ${SCRIPT}
	fi
done
