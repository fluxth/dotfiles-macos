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
    echo "Unlinking \"$dir\""
    stow -D "$dir"
done
