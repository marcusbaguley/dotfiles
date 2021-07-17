# Customised from Ben Orenstein's dot files

Vim-users will likely find useful stuff in my [vimrc](vimrc), and also my [Ruby snippets](vim/snippets/ruby.snippets).

I'm also a pretty aggressive aliaser. You might find a few you like in [zsh/aliases](zsh/aliases).

/Users/marcusbaguley/.gvimrc -> /Users/marcusbaguley/.vim/janus/vim/gvimrc
/Users/marcusbaguley/.vimrc -> /Users/marcusbaguley/.vim/vimrc

## tmux Installation

```
$ cd
$ git clone https://github.com/gpakosz/.tmux.git
$ ln -s -f .tmux/.tmux.conf
```

## Installation
  git clone git://github.com/r00k/dotfiles ~/.dotfiles
  cd ~/.dotfiles
  rake install

  Vim plugins are managed through vundle. You'll need to install vundle to get them.

  git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  Run :BundleInstall in vim.

## Dependencies Installation
1. Install asdf (Follow git install instructions)
```
asdf install
```

2. Install node packages for eslint and jsprettifier
```
npm install -g prettier
npm install -g eslint
```
