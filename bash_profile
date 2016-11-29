export PATH=/usr/local/sbin:/usr/local/bin:/usr/local/share/npm/bin:~/.docker-tools/bin:$PATH

# completions
source ~/.dotfiles/completion/git-completion.sh
source ~/.dotfiles/completion/bash_completion_tmux.sh
source ~/.dotfiles/completion/ssh_completion

export EDITOR=vim
export SHELL=/bin/bash


# go
export GOPATH=$HOME/golang
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

# alias, functions, prompt
source ~/.dotfiles/bash/aliases
source ~/.dotfiles/bash/functions
source ~/.dotfiles/bash/prompt

# LOYALTY_PROXY_URL="loyaltynetworkusername:password@192.168.90.90:8080"
LOYALTY_PROXY_URL="192.168.90.15:3128"
function noproxy () {
  unset http_proxy
  unset https_proxy
  unset no_proxy
  npm config delete proxy
  npm config delete https-proxy
}
function proxy () {
  location=$(scselect | grep "^ \*" | cut -d "(" -f2 | cut -d ")" -f1)
  if [ "$location" = "LoyaltyNetwork" ]; then
    export http_proxy="http://$LOYALTY_PROXY_URL"
    export https_proxy="https://$LOYALTY_PROXY_URL"
    export no_proxy=localhost,127.0.0.1,192.168.0.0/16,lnzl.co.nz,125.236.76.18,10.5.0.20,162.112.20.95,172.29.140.105,uatrev.flybuys.co.nz,rev.flybuys.co.nz,stagingrev.flybuys.co.nz,uatlittlebitgood.flybuys.co.nz,uatalittlebitgood.flybuys.co.nz,uatwww.littlebitgood.flybuys.co.nz,uatwww.alittlebitgood.flybuys.co.nz,uat.lab360.co.nz,api.txns.flybuys.co.nz,uatkibana.flybuys.co.nz,kibana.flybuys.co.nz,uat-api.txns.flybuys.co.nz,192.1.0.0/16
    npm config set proxy $http_proxy
    npm config set https-proxy $http_proxy
  else
    noproxy
  fi
  if env | grep -q proxy; then
    echo "Proxy enabled"
  fi
}
proxy

eval "$(rbenv init -)"
