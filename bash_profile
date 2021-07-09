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

