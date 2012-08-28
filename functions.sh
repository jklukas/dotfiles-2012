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
