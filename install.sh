#!/bin/bash
############################
# .install.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/.dotfiles
############################

########## Variables

CONFIG_DIR=~/.dotfiles                    # dotfiles directory
BACKUP_DIR=~/.dotfiles.bak             # old dotfiles backup directory
SCRIPT_DIR=~/.scripz                  # scripts directory

# list of files/folders to symlink in homedir
CONFIG_FILES="bashrc bash_aliases config/i3/config config/i3/i3blocks.conf Xresources compton.conf config/dunst/dunstrc"

##########

if [ -f "$BACKUP_DIR" ]; then
    echo "$BACKUP_DIR already exists. Please delete it manually."
fi

# back up config directory  in homedir
echo "Creating $BACKUP_DIR for backup of any existing dotfiles in ~"
mkdir -p $BACKUP_DIR
echo "...done"

# change to the dotfiles directory
echo "Changing to the $CONFIG_DIR directory"
cd $CONFIG_DIR
echo "...done"

# create scripts directory
echo "Creating a scripts directory"
mkdir -f $SCRIPT_DIR/sh
cp $CONFIG_DIR/scripz/* $SCRIPT_DIR/sh
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
for file in $CONFIG_FILES; do
    echo "Moving any existing dotfiles from ~ to $BACKUP_DIR"
    mv ~/.$file $BACKUP_DIR/
    echo "Creating symlink to $file in home directory."
    ln -s $CONFIG_DIR/$file ~/.$file
done

