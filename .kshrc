HOST=`hostname`

# The various escape codes that we can use to color our prompt.
        RED="[0;31m"
     YELLOW="[0;33m"
      GREEN="[0;32m"
       BLUE="[0;34m"
  LIGHT_RED="[1;31m"
LIGHT_GREEN="[1;32m"
      WHITE="[1;37m"
 LIGHT_GRAY="[0;37m"
 COLOR_NONE="[0m"
  BOLD_BLUE="[1;34m"
 BOLD_BLACK="[1m"

PS1="${BOLD_BLACK}[${BOLD_BLUE}${USER}${COLOR_NONE}@${BOLD_BLUE}${HOST}${BOLD_BLACK}] ${BLUE}${PWD}${COLOR_NONE}
${BOLD_BLUE}\$[0m "

