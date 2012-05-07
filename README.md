
This is essentially a bashrc framework for various modules.

Features
========

Colors are added in automatically. You set the prompt using $DOORMAT_PS1 and can reload the bashrc to see the changes (with color if detected). You set the colors in the config.

The configuration and init scripts are divided into modules, to make it easier to develop. Configuration values can be changed quickly by setting the variable and running `source ~/.bashrc`

A more static configuration may be generated using the flatten-rc.sh script

Configuration
=============
You can see all configuration parameters by running `set | grep ^DOORMAT`

You can change one temporarily by setting the variabl. You need to run `source ~/.bashrc` to apply the changes.

You can apply more long-term (or conditional) changes by adding files to the config directory. Files must be executable (`chmod +x`) before they are loaded

Screenshots
===========

Non-privileged User (non-root)
------------------------------
![Screenshot of prompt as normal user](http://reece45.com/projects/doormat/bash/2012-04-user.png)

Privileged User (root)
-----------------------
![Screenshot of prompt as root](http://reece45.com/projects/doormat/bash/2012-04-root.png)

Usage
=====
This is meant to be used inside something I call doormat, but it doesn't need to be. 

	mkdir ~/.doormat
	git clone https://github.com/AlReece45/doormat-bash .doormat/bash
	mv ~/.bashrc ~/.bashrc.bak-$(date +%Y-%m-%d) # Don't blame me if you lose your old .bashrc file
	ln -s ~/.doormat/bash/bashrc ~/.bashrc

Standard Stuff
==============
* For a normal user, the hostname and domain name show up in green.
* For a root user, the username is not show and the hostname and domain name show up in red.

Useful Stuff
============
* The far left is how long the last command took to run (from the time you push enter to the time the prompt runs) to the thousandth of a second.
* The hostname is bold and the domain name is not (hostname stands out)
* The @ sign is not bold, so you the username is easier to distinguish
* If the command took more than 60 seconds to run, it formats in in hh:mm format
* The far right ($ or # depending on the user), is GREEN if the command ran successfully and RED when it returns an error code
* If the command returns an error code, the error code is displayed between the directory and the prompt sign (in red)
* PS1 is configured easily (without worring about colors). Colors are added to PS1 when support is detected

Things to fix
=============
* Crappy DNS servers slow down login time for some reason (should just be a read from /etc/hosts)
* Should write a script to output this to one .bashrc file
