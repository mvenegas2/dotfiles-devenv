export AFSHOST=cs:

# alias emacs='/Applications/Emacs.app/Contents/MacOS/Emacs -nw'
alias ssh="ssh -Y"
alias sl='ls'
alias pbcopy='reattach-to-user-namespace pbcopy'

export PATH=$PATH:"$HOME/.dotfiles"
export EDITOR='emacs -nw'

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd
unsetopt beep extendedglob nomatch notify
bindkey -e
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

export GOPATH=/opt/go
export PATH=$PATH:/opt/go/bin:$GOPATH/bin:$HOME/.local/bin
export NG_CLI_ANALYTICS=ci
