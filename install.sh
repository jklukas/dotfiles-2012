#!/bin/sh

# Change to the script's directory
cd $(dirname $0)

for TARGET in *.symlink bash_profile.symlink; do
    BASENAME=${TARGET%.*}
    DOTFILE=~/.$BASENAME
    if [ -h $DOTFILE ]; then
        unlink $DOTFILE
    elif [ -f $DOTFILE ]; then
        [ -d backup ] || mkdir backup
        echo "Moving existing $DOTFILE to $PWD/backup/$BASENAME"
        mv $DOTFILE backup/$BASENAME
    fi
    [ -f $TARGET ] && ln -s $PWD/$TARGET $DOTFILE
done

[ ! -f ~/.myenv ] && echo "export CONFIGDIR=$PWD" > ~/.myenv
[ ! -d ~/.myflags ] && mkdir ~/.myflags
