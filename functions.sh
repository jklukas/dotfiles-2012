#!/bin/sh

# Usage: puniq [<path>]
# Remove duplicate entries from a PATH style value while retaining
# the original order. Use PATH if no <path> is given.
#
# Example:
#   $ puniq /usr/bin:/usr/local/bin:/usr/bin
#   /usr/bin:/usr/local/bin
puniq () {
    echo "$1" |tr : '\n' |nl |sort -u -k 2,2 |sort -n |
    cut -f 2- |tr '\n' : |sed -e 's/:$//' -e 's/^://'
}

# Usage: xsource <path>
# Source <path> if it exists.
xsource () {
    [ -f $1 ] && . $1
}

# Usage: solarize
# Set up environment for solarized colors
solarize () {
    eval `dircolors $CFGDIR/dircolors.ansi-dark`
}

# Usage: rmtilde <path>
# Remove all files ending in ~ from $PWD or <path>
rmtilde () {
    DIR=$1
    [ -z "$DIR" ] && DIR=$PWD
    ls -A $DIR | grep '~$' | xargs rm
}

# Usage: searchhist <term>
# Search for <term> in the shell history
searchhist () {
    history -a
    history | grep $1
}

# Aliases
alias ls='ls --color'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias google-chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'

# Generate aliases to quickly csession into each %SYS and APP namespace on the system.
# An instance called BLD with environments JMH and CHP will generate aliases bldsys, jmh, and chp.
if [ -x /epic/bin/epiccontrol ]; then
    alias_environments () {
	INST=$1
	shift
	alias ${INST}sys="csession $INST -U %sys"
	for E in $@; do
    	    alias $E="csession $INST -U $E";
	done
    }
    ENVIRONMENTS=`/epic/bin/epiccontrol printenvs 2> /dev/null | tail -n +3 | tr ',' ' ' | tr 'A-Z' 'a-z'`
    OLDIFS=$IFS
    IFS='\n'
    for x in $ENVIRONMENTS; do
	IFS=$OLDIFS
	alias_environments $x
    done
    IFS=$OLDIFS
fi
