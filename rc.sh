# Settings for all interactive shells
# Called by .bashrc and .kshrc

set -o emacs

CNULL="[m"
CRED="[31m"
CBOLDRED="[1m[31m"
CREDBG="[41m"

exit_status () {
    EXIT=$?
    if [ "$EXIT" != "0" ]; then
        echo "${CRED}$EXIT${CNULL} "
    fi
}

prompt_jobs () {
    NJOBS=$(jobs | sed -n '$=')
    JOBSTR=jobs
    [ "$NJOBS" = "1" ] && JOBSTR=job
    [ -n "$(jobs)" ] && printf "(%d $JOBSTR)" $(jobs | sed -n '$=')
}

current_status () {
    prompt_jobs
    __git_ps1 "(%s)" 2> /dev/null
}

PRODPS1="${CREDBG}"'[`whoami`@`hostname`] `pwd`'" ${CNULL}
PROD $ "

PS1='`exit_status`'"[${CBOLDRED}"'`whoami`'"${CNULL}@${CBOLDRED}"'`hostname`'"${CNULL}] "'`pwd`'"
"'$(current_status)$ '

if [ -f ~/.myflags/prod ]; then PS1=$PRODPS1; fi
