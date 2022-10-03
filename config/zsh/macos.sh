alias pblast="echo \$(fc -ln -1) | tr -d '\n' | tee /dev/tty | pbcopy"
# Add GNU path for GNU tools installed by brew, e.g. make
PATH="/usr/local/opt/make/libexec/gnubin:$PATH"
