#!/bin/sh

UNDESIRED_FILES="bash_profile.symlink bash_login.symlink emacs.symlink"

# Change to the script's directory
cd $(dirname $0)

for TARGET in *.symlink *.d $UNDESIRED_FILES; do
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

echo "export CFGDIR=$PWD" >> ~/.myenv
[ ! -d ~/.myflags ] && mkdir ~/.myflags

# Load machine-specific environment
. ~/.myenv
