#!/usr/bin/env zsh

# A setup script for new machines to uniformly setup new machines.

HOSTNAME=$(cat /etc/hostname)
configdir=~/c

mkdir -p ~/.config

ln -s "$configdir/config/user-dirs.dirs" ~/.config/user-dirs.dirs

ln -s "$configdir/tmux.conf" ~/.tmux.conf

ln -s "$configdir/zsh" ~/.zsh
ln -s "~/.zsh/zshrc" ~/.zshrc

### SWAY ##################

make_sway_symlink() {
    local scriptname=$1
    #local machinespecific=${2:no}
    ln -s "$configdir/sway/$scriptname" $SWAY_DIR/$scriptname
}

SWAY_DIR=~/.config/sway
mkdir $SWAY_DIR
ln -s "$configdir/sway/config" $SWAY_DIR/config
ln -s "$configdir/sway/idle-$HOSTNAME" $SWAY_DIR/idle
ln -s "$configdir/sway/input-$HOSTNAME" $SWAY_DIR/input
make_sway_symlink init-brightnessbar.sh
make_sway_symlink init-volumebar.sh
make_sway_symlink status.sh
make_sway_symlink bg-shuffle.sh


