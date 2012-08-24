[ -z "$CONFIGDIR " ] && echo "Define CONFIGDIR in ~/.myenv"  && die 1

echo "In environment.sh"

# Build the executable path
test -d "$HOME/bin" && PATH="$HOME/bin:$PATH"
test -d "$HOME/.bin" && PATH="$HOME/.bin:$PATH"
export PATH=$(puniq $PATH)

export EDITOR=emacs
export PAGER=less
