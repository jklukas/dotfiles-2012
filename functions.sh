#!/bin/sh

# Usage: puniq [<path>]
# Remove duplicate entries from a PATH style value while retaining
# the original order. Use PATH if no <path> is given.
#
# Example:
#   $ puniq /usr/bin:/usr/local/bin:/usr/bin
#   /usr/bin:/usr/local/bin
puniq () {
    echo "$1" | tr : '\n' | nl |sort -u -k 2,2 | sort -n |
    cut -f 2- | paste -s -d':' - | sed -e 's/:$//' -e 's/^://'
}

# Usage: padd [<path>]
# Add <path> to $PATH unless it doesn't exist.
padd () {
    for DIR in $@; do
        [ -d $DIR ] && PATH="$DIR:$PATH"
    done
}


# Usage: xsource <path>
# Source <path> if it exists.
xsource () {
    [ -f $1 ] && . $1
}


# Usage: aliasflags <cmd> <flag1> <flag2> ...
# If all flags exist, alias <cmd> to the same command with flags
aliasflags () {
    cmd=$1
    shift
    if $cmd $@ > /dev/null 2>&1; then
        alias $cmd="$cmd $@"
    fi
}


# Usage: sshpush <hostname>
# Push this machine's public key to remote host given by <hostname>
sshpush () {
    cat ~/.ssh/id_rsa.pub | \
        ssh $1 "umask 077; test -d ~/.ssh || mkdir ~/.ssh; cat >> ~/.ssh/authorized_keys || exit 1"
}

# Usage: solarize
# Set up environment for solarized colors
solarize () {
    eval `dircolors $CFGDIR/dircolors.ansi-dark`
}

# Usage: rmtilde <path>
# Remove all files ending in a tilde from <path> (default $PWD)
rmtilde () {
    DIR=$1
    [ -z "$DIR" ] && DIR=$PWD
    /bin/ls -A $DIR | grep '~$' | xargs rm
}


# Usage: searchhist <term>
# Search for <term> in the shell history
searchhist () {
    history -a
    history | grep $1
}


# Usage: rainbow
# Display a lovely rainbow
rainbow () {
    echo "$(seq 231 -1 16)" | while read i; do 
	printf "\x1b[48;5;${i}m\n"
	sleep 0.02
    done
}

# Aliases
aliasflags ls -G
aliasflags ls --color
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias google-chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'

# Generate aliases to quickly csession into each %SYS and APP namespace on 
# the system. An instance called BLD with environments JMH and CHP will 
# generate three aliases:
#     bldsys='csession bld -U %sys'
#     jmh='csession bld -U jmh'
#     chp='csession bld -U chp'
if [ -x /epic/bin/epiccontrol ]; then
    ENVFILE=/tmp/$$.printenvs
    /epic/bin/epiccontrol printenvs 2>/dev/null \
        | tail -n +3 \
        | grep -v "No Epic environments" \
	| tr ',' ' ' \
	| tr 'A-Z' 'a-z' \
	> $ENVFILE
    while read INSTANCE ENVIRONMENTS; do
	alias ${INSTANCE}sys="csession $INSTANCE -U %sys"
        BINDIR=`ccontrol list | grep ${INSTANCE}/cachesys | awk '{ print $2 }' | sed 's/cachesys/bin/'`
        for CMD in $BINDIR/*; do
            if [ -f $CMD ] && [ -x $CMD ]; then
                CMDNAME=`basename $CMD`
                alias ${INSTANCE}${CMDNAME}=${CMD}
            fi
        done
	for ENVIRONMENT in $ENVIRONMENTS; do
	    alias ${ENVIRONMENT}="csession $INSTANCE -U $ENVIRONMENT";
            alias ${ENVIRONMENT}strt="csession $INSTANCE -U $ENVIRONMENT ^%ZdUSTRT"
            alias ${ENVIRONMENT}look="csession $INSTANCE -U $ENVIRONMENT ^%ZeW"
            alias ${ENVIRONMENT}x="csession $INSTANCE -U $ENVIRONMENT ^X1EPIC"
	done
    done < "$ENVFILE"
    rm $ENVFILE
fi
