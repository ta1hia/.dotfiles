# ~/.bash_aliases: imported by ~/bashrc.

# Source scripts
for f in ~/.scripz/sh/*; do 
    . $f
done

# Re-alias
alias mkdir='mkdir -pv'
alias top='htop'
alias rm='rm -i'
alias ls='ls -lhg --color=always --group-directories-first'
alias ll='ls -AlFh'
alias la='ls -A'
alias l='LC_COLLATE=C ls -C'

# Custom
alias v='vim -p'
alias dk='docker'
alias bashrc='vim -p ~/.bash_aliases ~/.bashrc ~/.bash_profile'
alias sbashrc='source ~/.bashrc'
alias prettyjson='python -m json.tool'

# cd into a directory and call l
function cl(){ cd "$@" && l; }

# set gopath to current directory
function gopath() { export GOPATH=`pwd`;}

# start a shell in a running docker
function dockerbash() { docker exec -i -t $1 /bin/bash; }
