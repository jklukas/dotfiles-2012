#!/bin/bash
# My configurations.
# Some ideas taken from https://github.com/rtomayko/dotfiles

# Set defaults if these don't exist.
: ${HOME=~}
: ${LOGNAME=$(id -un)}
: ${UNAME=$(uname)}

# Bring in the system's bashrc
test -r /etc/bashrc && . /etc/bashrc

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

# Build the executable path
test -d "$HOME/bin" && PATH="$HOME/bin:$PATH"
export PATH=$(puniq $PATH)

export EDITOR=emacs

# Settings for saving of command history
export HISTFILE=~/.bash_history
unset HISTFILESIZE
HISTSIZE=10000
PROMPT_COMMAND="history -a"
export HISTSIZE PROMPT_COMMAND
export HISTIGNORE="&:ls:exit:cd:searchHistory*"
export HISTCONTROL=erasedups

# Setup for todo.txt app
PATH=$PATH:$HOME/Dropbox/ToDo
alias t='todo.sh'
alias tl='todo.sh ls'
alias ta='todo.sh a'

# Aliases
alias ls='ls --color'
alias rmtilde='rm *~'
alias nemacs='emacs -nw'
alias lwisc='klog jklukas@hep.wisc.edu'
alias lcern='klog klukas@cern.ch'
alias sshfnal='kinit klukas@FNAL.GOV; ssh -X klukas@cmslpc-sl5.fnal.gov'
alias sshpnfs='gsissh -p 222 cmsgrid02.hep.wisc.edu'

alias condorq='condor_q | sed "s/     //"'
alias setcvscern='export CVSROOT=:gserver:cmscvs.cern.ch:/cvs_server/repositories/CMSSW; kinit klukas@CERN.CH'
alias setcvswisc='export CVSROOT=/afs/hep.wisc.edu/cms/CVSRepository; export CVS_RSH='
alias mergePdf='gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=merged.pdf'
alias searchHistory='history | grep'

# Fix things for working on local Mac
if [ "$UNAME" = "Darwin" ]; then
    export PATH="/Library/Frameworks/EPD64.framework/Versions/Current/bin:$PATH"
    export PYTHONPATH=$PYTHONPATH:/usr/local/lib/root
    alias ls='ls -G'
    alias sshwisc='ssh -Y jklukas@login.hep.wisc.edu'
    alias sshcern='ssh -Y klukas@lxplus.cern.ch'
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function
fi

# Change the default prompt
. ~/.git_svn_bash_prompt

# Wrappers around scp
function body_scpToWisc { set +f; scp -o"ProxyCommand ssh jklukas@login.hep.wisc.edu nc $1 22 2>/dev/null" $2 jklukas@$1.hep.wisc.edu:$3; }
alias scpToWisc='set -f; body_scpToWisc'
function body_scpFromWisc { set +f; scp -o"ProxyCommand ssh jklukas@login.hep.wisc.edu nc $1 22 2>/dev/null" jklukas@$1.hep.wisc.edu:$2 $3; }
alias scpFromWisc='set -f; body_scpFromWisc'

# Other useful functions
function findBiggest { find . -size +1000k -ls | sort -nr -k 7 | awk '{print $7,$11}'; }
function condorql { condor_q -l $1 | grep UserLog; }
function condorqs { condor_q -l | grep UserLog | grep $1; }
