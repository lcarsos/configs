#!/usr/bin/env zsh

# A setup script for new machines to uniformly setup new machines.

configdir=${CONFIG_DIR:~/c}

mkdir -p ~/.config

ln -s "$configdir/config/user-dirs.dirs" ~/.config/user-dirs.dirs

ln -s "$configdir/tmux.conf" ~/.tmux.conf

ln -s "$configdir/zsh" ~/.zsh
ln -s "~/.zsh/zshrc" ~/.zshrc
