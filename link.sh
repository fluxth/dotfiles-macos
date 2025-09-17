#!/usr/bin/env bash -e

LINK_DIRS=(
    yabai
    skhd
    spacebar
    alacritty
    karabiner
    zsh
    tmux
    git
)

for dir in "${LINK_DIRS[@]}"; do
    echo "Linking \"$dir\""
    stow "$dir"
done
