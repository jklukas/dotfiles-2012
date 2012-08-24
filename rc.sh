# Settings for all interactive shells
# Called by .bashrc and .kshrc

CNULL="[m"
CBOLDRED="[1m[31m"
CREDBG="[41m"

PS1="[${CBOLDRED}"'`whoami`'"${CNULL}@${CBOLDRED}"'`hostname`'"${CNULL}] "'`pwd`'"
$ "
[ -f ~/.myflags/prod ] && PS1="${CREDBG}"'[`whoami`@`hostname`] `pwd`'" ${CNULL}
PROD $ "
