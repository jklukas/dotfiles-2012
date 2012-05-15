if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

PATH=$PATH:$HOME/bin

export PATH
unset USERNAME
export EDITOR=emacs

USING_MACOSX=false
if [ `uname` == "Darwin" ]; then USING_MACOSX=true; fi

addto () {
    STRING=$1
    NEW=$2
    AFTER=$3
    case "${STRING}" in
        ${NEW} | ${NEW}:* | *:${NEW} | *:${NEW}:*) ;;
        *) [ "${AFTER}" = "after" ] && \
            STRING="${STRING}:${NEW}" || STRING="${NEW}:${STRING}" ;;
    esac
    echo ${STRING}
}

if [ "$USING_MACOSX" == "false" ]; then
    case "$HOSTNAME" in 
        *hep.wisc.edu )
	    if [ -f /afs/hep.wisc.edu/cms/setup/bashrc ]; then
	        . /afs/hep.wisc.edu/cms/setup/bashrc
	    fi
	    if [ -f ~/.mozilla/firefox/a0y0n443.default/.parentlock ]; then
	        rm ~/.mozilla/firefox/a0y0n443.default/.parentlock
	    fi
            source /afs/hep.wisc.edu/src/rootplot/rootplot_setup.sh
	    ;; 
        *cern.ch | pcwiscms* )
	    stty sane
            source ~/public/Sharing/rootplot_setup.sh
 	    ;;
        *fnal.gov )
	    source /uscmst1/prod/sw/cms/shrc uaf
	    ;;
    esac
fi

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
alias jemacs='emacs -fn 6x12 -geometry 80x48'
alias nemacs='emacs -nw'
alias lwisc='klog jklukas@hep.wisc.edu'
alias lcern='klog klukas@cern.ch'
alias sshfnal='kinit klukas@FNAL.GOV; ssh -X klukas@cmslpc-sl5.fnal.gov'
alias sshpnfs='gsissh -p 222 cmsgrid02.hep.wisc.edu'

alias cmssetwa=' eval `scramv1 runtime -sh` ; export PATH=${PATH}:$CMSSW_RELEASE_BASE/test/$SCRAM_ARCH ; setPython '
alias setPython='export PYTHONPATH=$PYTHONPATH:./:$CMSSW_BASE/src/. ; export PYTHONSTARTUP=~/.pythonrc '
alias fwlite='root ~/.fwlite.C -l '

alias condorq='condor_q | sed "s/     //"'
alias setcvscern='export CVSROOT=:gserver:cmscvs.cern.ch:/cvs_server/repositories/CMSSW; kinit klukas@CERN.CH'
alias setcvswisc='export CVSROOT=/afs/hep.wisc.edu/cms/CVSRepository; export CVS_RSH='
alias mergePdf='gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=merged.pdf'
alias searchHistory='history | grep'

function rotatepdf { gs -q -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -dAutoRotatePages=/All -sOutputFile=TEMP.pdf $1; mv TEMP.pdf $1; }

function findText {
    # Example: findText gSystem "*.C"
    SEARCHSTRING=$1; shift
    find . -name "$@" -exec grep $SEARCHSTRING '{}' \; -print
}

function printDcachePaths {
    echo file://localhost//$PWD
    echo srm://cmssrm.hep.wisc.edu:8443//pnfs/hep.wisc.edu/store/user/jklukas/
    echo srm://cmssrm.fnal.gov:8443/resilient/klukas/
    echo dcap://cmsdcap.hep.wisc.edu:22125/pnfs/hep.wisc.edu/store/user/jklukas/
    echo dcap://cmsgridftp.fnal.gov:24125/pnfs/fnal.gov/usr/cms/WAX/resilient/klukas/

}

function makeRelValScript {
    if [ -z "$CMSSW_VERSION" ]; then echo "Please run cmsenv"; return; fi
    OUT_FILE="many.sh"
    args=$@
    if [[ $# -eq 0 ]]; then args=$CMSSW_VERSION; fi
    for arg in $args; do
        if [[ $arg == CMSSW* ]]; then
            dbs lsd --path=/RelVal*/$arg-*/* \
                | egrep "GEN-SIM-RECO|GEN-SIM-DIGI-RECO" \
                | egrep "JpsiMM/|ZMM/|WM/|TTbar/|SingleMuPt10{1,3}/" \
                | grep -v "ProdTTbar/" \
                | sort --reverse \
                | sed "s;/RelVal;./runRelVal.sh /RelVal;" \
                >> temp.sh
        else
            OUT_FILE=$arg
        fi
    done
    mv temp.sh $OUT_FILE
    chmod +x $OUT_FILE
}

function makeRelValIntegration {
    globalTag=`dbs lsd --path=/RelValZMM/$CMSSW_VERSION-*/* | grep HLTDEBUG | 
               tail -n 1 | sed "s/.*\(START.*\)-v.*/\1/"`; 
    echo $globalTag
    cmsDriver.py SingleMuPt10.cfi -s GEN,SIM,DIGI,L1,DIGI2RAW,HLT -n 10 --eventcontent FEVTDEBUGHLT --conditions $globalTag::All --mc
    cmsDriver.py step2 -s RAW2DIGI,RECO,VALIDATION,DQM -n 10 --filein file:SingleMuPt10_cfi_GEN_SIM_DIGI_L1_DIGI2RAW_HLT.root --eventcontent RECOSIM --conditions $globalTag::All --mc
    cmsDriver.py step3 -s HARVESTING:validationHarvesting+dqmHarvesting --harvesting AtRunEnd --conditions $globalTag::All --filein file:step2_RAW2DIGI_RECO_VALIDATION_DQM.root --mc
    cmsDriver.py SingleMuPt10_cfi.py -s GEN,FASTSIM,VALIDATION --pileup=NoPileUp --conditions auto:mc --eventcontent=FEVTDEBUGHLT --datatier GEN-SIM-DIGI-RECO -n 10
    cmsDriver.py step3 -s HARVESTING:validationHarvestingFS --harvesting AtRunEnd --conditions $globalTag::All --filein file:SingleMuPt10_cfi_py_GEN_FASTSIM_VALIDATION.root --mc
}

# Fix things for working on local Mac
if [ "$USING_MACOSX" = "true" ]; then
    export PATH=/Library/Frameworks/EPD64.framework/Versions/Current/bin:$PATH
    export PYTHONPATH=$PYTHONPATH:/usr/local/lib/root
    alias ls='ls -G'
    alias sshwisc='ssh -Y jklukas@login.hep.wisc.edu'
    alias sshcern='ssh -Y klukas@lxplus.cern.ch'
    alias jemacs='/Applications/Emacs.app/Contents/MacOS/Emacs -geometry 80x48'
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function
fi

# Change the default prompt
# PS1="\[\033[1;30m\][\[\033[1;34m\]\u\[\033[1;30m\]@\[\033[0;35m\]\h\[\033[1;30m\]] \[\033[0;35m\]\w
# \[\033[1;35m\]\$\[\033[0m\] "
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

# Cleaner function for TeXing
function mytex {
    texfile=${1%.*}
    if [[ -z $1 ]]; then
        echo "Please provide a filename"
        exit
    fi
    tmpdir="/tmp/mytex$PWD/$texfile"
    mkdir -p "$tmpdir"
    for f in `/bin/ls "$tmpdir"`; do
        if [ "$f" != "$texfile.tex" ]; then
            cp "$tmpdir/$f" .
        fi
    done
    pdflatex $texfile
    find "$PWD" -name "$texfile.*" ! -name "*.tex" ! -name "*.pdf" -exec mv {} "$tmpdir" \;
}
