#!/bin/sh

# Change to the script's directory
cd $(dirname $0)

for TARGET in *.symlink *.d bash_profile.symlink emacs.symlink; do
    BASENAME=${TARGET%.*}
    [ -d $TARGET ] && BASENAME=${TARGET}
    DOTFILE=~/.$BASENAME
    if [ -h $DOTFILE ]; then
        unlink $DOTFILE
    elif [ -w $DOTFILE ]; then
        [ -d backup ] || mkdir backup
        echo "Moving existing $DOTFILE to $PWD/backup/$BASENAME"
        mv $DOTFILE backup/$BASENAME
    fi
    [ -r $TARGET ] && ln -s $PWD/$TARGET $DOTFILE
done

[ ! -f ~/.myenv ] && echo "export CFGDIR=$PWD" > ~/.myenv
[ ! -d ~/.myflags ] && mkdir ~/.myflags

# Load machine-specific environment
. ~/.myenv
