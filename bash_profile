export PATH=/usr/local/sbin:/usr/local/bin:/usr/local/share/npm/bin:~/.docker-tools/bin:$PATH

# completions
source ~/.dotfiles/completion/git-completion.sh
source ~/.dotfiles/completion/bash_completion_tmux.sh
source ~/.dotfiles/completion/ssh_completion

export EDITOR=vim
export SHELL=/bin/bash


# alias, functions, prompt
source ~/.dotfiles/bash/aliases
source ~/.dotfiles/bash/functions
source ~/.dotfiles/bash/prompt

. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

export PATH="/usr/local/opt/libpq/bin:$PATH"
