# Settings for all interactive shells
# Called by .bashrc and .kshrc

# This is mostly about setting up a nice PS1
# ksh88 will ony do variable substitution on PS1, not command or path subs
# The terminal emulator may get confused by color sequences, since it doesn't
# know whether to include those characters in the line count or not
# This can be helped by \[color\] notation, but this is not always interpreted
# so it seems safest to leave them off and make sure all the fancy colors are
# on their own line.

set -o emacs

ESC=$(printf "\033")
BEL=$(printf "\007")
CFT=$(printf "${ESC}[m")
#CFT=$(printf "\[${ESC}[m\]")

xtitle () {
    title=$1
    printf "\033]0;${title}\007"
}

sgr () {
    printf "${ESC}[${1};${2};${3}m"
    #printf "\[${ESC}[${1};${2};${3}m\]"
}

color () {
    printf "${ESC}[3${1}m"
    #printf "\[${ESC}[3${1}m\]"
}

boldcolor () {
    printf "${ESC}[1;3${1}m"
    #printf "\[${ESC}[1;3${1}m\]"
}

exit_status () {
    EXIT=$?
    if [ "$EXIT" != "0" ]; then
        #printf "$(color 1)"
        #printf "${EXIT}${CFT}"
        printf "$(color 1)$EXIT${CFT} "
        #printf "${EXIT} "
    fi
}

shorthost () {
    hostname=$(hostname)
    printf ${hostname%%.*}
}

prompt_jobs () {
    NJOBS=$(jobs | sed -n '$=')
    JOBSTR=jobs
    [ "$NJOBS" = "1" ] && JOBSTR=job
    [ -n "$(jobs)" ] && printf "(%d $JOBSTR)" $(jobs | sed -n '$=')
}

prompt_csession () {
    # The -c in ps means that only commands are shown (no arguments)
    [ -n "$(ps -c | grep cache)" ] && echo "(csession)"
}

current_status () {
    prompt_jobs
    prompt_csession
    __git_ps1 "(%s)" 2> /dev/null
}

setprompt_simple () {
    PS1='$ '
}

setprompt_color () {
    mytitle="$(whoami)@$(shorthost)"
    xtitle='$(xtitle ${mytitle})'
    exit_status='$(exit_status)'
    whoami=$(boldcolor 1)'$(whoami)'${CFT}
    hostname=$(boldcolor 1)'$(shorthost)'${CFT}
    pwd='$(pwd)'
    current_status='$(current_status)'
    PS1="${exit_status}${xtitle}${CFT}[${whoami}@${hostname}] ${pwd}${CFT}
${current_status}\$ "
}

PRODPS1="${CREDBG}"'[`whoami`@`hostname`] `pwd`'" ${CNULL}
PROD $ "

setprompt_color

# In bash, change title by including in PROMPT_COMMAND: echo -ne "\033]0;Title to display\007"

if [ -f ~/.myflags/prod ]; then PS1=$PRODPS1; fi
