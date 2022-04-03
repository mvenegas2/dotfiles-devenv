#!/bin/bash -ex

rm -rf ~/.oh-my-zsh
git clone https://github.com/robbyrussell/oh-my-zsh ~/.oh-my-zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

sudo chsh -s /bin/zsh $USER

rm -rf ~/.dotfiles
mv ~/dotfiles ~/.dotfiles
ln -fs ~/.dotfiles/dotsyncrc ~/.dotsyncrc

cd ~/.dotfiles
./dotsync -I
./dotsync -L

# goodies
sudo apt-get update
sudo apt-get install -y tig software-properties-common

# upgrade emacs
sudo apt-get remove 'emacs*'
yes | sudo add-apt-repository ppa:ubuntu-elisp/ppa
sudo apt-get update
sudo apt-get install -y emacs-snapshot gnupg2
