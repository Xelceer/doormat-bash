
I cleaned up my bash (shell) configuration and broke it up into seperate files and modules. I didn't really plan on sharing it, but others may find it useful and it makes distribution on my part very simple.

The prompt looks a little like this (with a few more colors):

[$runtime] $username@[$hostname].[$domainname] # \W $

Usage
=====
This is meant to be used inside something I call doormat, but it doesn't need to be. 

	mkdir .doormat
	git clone https://github.com/AlReece45/doormat-bash bash
	ln -s ~/.doormat/bash/bashrc ~/.bashrc

Standard Stuff
==============
* For a normal user, the hostname and domain name show up in green.
* For a root user, the username is not show and the hostname and domain name show up in red.

Useful Stuff
============
* The hostname is bold and the domain name is not (hostname stands out)
* The @ sign is not bold, so you the username is easier to distinguish
* The far left is how long the last command took to run (from the time you push enter to the time the prompt runs).
* If the command took more than 60 seconds to run, it formats in in hh:mm format
* The far right ($ or # depending on the user), is GREEN if the command ran successfully and RED when it returns an error code
* If the command returns an error code, the error code is displayed between the directory and the prompt sign (in red)

Things to fix
=============
* The $runtime does does not do color-detection
* The $status script should do color-detection
* The prompt-color script could use a lot of cleaning up