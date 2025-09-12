#!/usr/bin/env zsh

# A setup script for new machines to uniformly setup new machines.

if [[ -f /etc/hostname ]]; then
	HOSTNAME=$(cat /etc/hostname)
else
	HOSTNAME=$(hostname -s)
fi
configdir=${0:a:h}

basicconfig() {
    mkdir -p ~/.config

    ln -s "$configdir/config/user-dirs.dirs" ~/.config/user-dirs.dirs
}

config_tmux() {
    ln -s "$configdir/tmux.conf" ~/.tmux.conf
}

config_zsh() {
    if [[ -f ~/.zprofile && ! -L ~/.zprofile ]]; then rm ~/.zprofile ; fi
    if [[ -f ~/.zshenv && ! -s ~/.zshenv ]]; then rm ~/.zshenv ; fi
    if [[ -f ~/.zshrc &&  ! -s ~/.zshrc ]]; then rm ~/.zshrc ; fi

    if [[ $OSTYPE != "darwin"* ]]; then
        ADDL_LN_FLAGS="-T"
    fi
    if [[ ! -L ~/.zsh ]]; then ln -s $ADDL_LN_FLAGS "$configdir/zsh" ~/.zsh ; fi
    if [[ ! -L ~/.zprofile ]]; then ln -s "$configdir/zsh/zprofile" ~/.zprofile ; fi
    if [[ ! -L ~/.zshenv ]]; then ln -s "$configdir/zsh/zshenv" ~/.zshenv ; fi
    if [[ ! -L ~/.zshrc ]]; then ln -s "$configdir/zsh/zshrc" ~/.zshrc ; fi
}

### SWAY ##################

make_sway_symlink() {
    local scriptname=$1
    #local machinespecific=${2:no}
    ln -s "$configdir/sway/$scriptname" $SWAY_DIR/$scriptname
}

config_sway() {
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
    mkdir ~/.xkb/symbols
    ln -s "$configdir/sway/ppdv.xkb" ~/.xkb/symbols/us
}

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

config_kitty() {
    KITTY_DIR=~/.config/kitty
    mkdir $KITTY_DIR
    make_kitty_symlink kitty.conf
    make_kitty_symlink theme.conf
    make_kitty_symlink font.conf
}

### Do Configure ##########

basicconfig
config_tmux
config_zsh
config_kitty
