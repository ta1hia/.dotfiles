# ~/.bash_aliases: imported by ~/bashrc.

# Source scripts
SCRIPTS_DIR=~/.scripz
if [ -d "$SCRIPTS_DIR" ]; then
    for f in ~/.scripz/sh/*; do 
        . $f
    done
fi

# Re-alias
alias mkdir='mkdir -pv'
alias top='htop'
alias rm='rm -i'
alias ls='ls -lhg'
alias ll='ls -AlFh'
alias la='ls -A'
alias l='ls -C'

alias v='vim -p'
alias dk='docker'
alias bashrc='vim -p ~/.bash_aliases ~/.bashrc ~/.bash_profile'
alias sbashrc='source ~/.bash_profile'
alias prettyjson='python -m json.tool'

# Directories 
alias migo='cd $HOME/dev/go/src/github.com/tahia-khan'

# Keyboard
#alias setcolemak='setxkbmap -layout us -variant colemak && setxkbmap -option caps:escape'
#alias setstandard='setxkbmap -layout us && setxkbmap -option caps:escape'

# cd into a directory and call l
function cl(){ cd "$@" && l; }

# set gopath to current directory
function gopath() { export GOPATH=`pwd`;}

# start a shell in a running docker
function dockerbash() { docker exec -i -t $1 /bin/bash; }
