#!/usr/bin/env zsh

# A setup script for new machines to uniformly setup new machines.

HOSTNAME=$(cat /etc/hostname)
configdir=~/c

mkdir -p ~/.config

ln -s "$configdir/config/user-dirs.dirs" ~/.config/user-dirs.dirs

ln -s "$configdir/tmux.conf" ~/.tmux.conf

ln -s -T "$configdir/zsh" ~/.zsh
ln -s "$configdir/zsh/zshrc" ~/.zshrc

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
ln -s "$configdir/sway/monitor-$HOSTNAME" $SWAY_DIR/monitor
ln -s "$configdir/sway/status-$HOSTNAME" $SWAY_DIR/status
make_sway_symlink init-brightnessbar.sh
make_sway_symlink init-volumebar.sh
make_sway_symlink status.sh
make_sway_symlink bg-shuffle.sh

### KITTY #################

make_kitty_symlink() {
    local scriptname=${1%.conf}
    #local machinespecific=${2:no}
    if [ -f "$KITTY_DIR/$scriptname.conf" ]; then
        rm "$KITTY_DIR/$scriptname.conf"
    fi

    if [ -f "$configdir/config/kitty/$scriptname-$HOSTNAME.conf" ]; then
        ln -s "$configdir/config/kitty/$scriptname-$HOSTNAME.conf" "$KITTY_DIR/$scriptname.conf"
    elif [ -f "$configdir/config/kitty/$scriptname.conf" ]; then
        ln -s "$configdir/config/kitty/$scriptname.conf" "$KITTY_DIR/$scriptname.conf"
    else
        >&2 echo "No kitty config found for ${scriptname}.conf"
    fi
}

KITTY_DIR=~/.config/kitty
mkdir $KITTY_DIR
make_kitty_symlink kitty.conf
make_kitty_symlink theme.conf
make_kitty_symlink font.conf
