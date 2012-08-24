#!/bin/sh

echo "In functions.sh"

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

# Usage: sshpush <user@hostname>
# Push public ssh key to a server.
sshpush () {
    cat ~/.ssh/id_rsa.pub | ssh $1 'cat >> .ssh/authorized_keys'
}

# Usage: solarize
# Set up environment for solarized colors
solarize () {
    eval `dircolors $CONFIGDIR/dircolors.ansi-dark`
}

# Usage: rmtilde <path>
# Remove all files ending in ~ from $PWD or <path>
rmtilde () {
    DIR=$1
    [ -z "$DIR" ] && DIR=$PWD
    rm $DIR/*~
}

# Aliases
alias ls='ls --color'
alias nemacs='emacs -nw'
alias search-history='history | grep'

