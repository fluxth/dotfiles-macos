# dotfiles-macos

## Quick Start

```bash
# Show help / list of commands
./manage.sh

# Install everything
./manage.sh install

# Update everything
./manage.sh update

# Link dotfiles
./manage.sh link

# Unlink dotfiles
./manage.sh unlink

# Install specific components
./manage.sh install homebrew
./manage.sh install formulas
./manage.sh install omz

# Update specific components
./manage.sh update homebrew
./manage.sh update zsh-plugins
./manage.sh update dotfiles
```

## Manual setup steps

There's only so much you can put into dotfiles in macOS...

- Go into `System Settings`
    - `Desktop & Dock` and set all `Hot Corners...` to `OFF`
    - `Desktop & Dock > Mission Control` and set `Automatically rearrange Spaces based on most recent use` to `OFF`
    - `Desktop & Dock > Desktop & Stage Manager` and set `Click wallpaper to reveal desktop` to `Only in Stage Manager`
    - `Keyboard Shortcuts > Mission Control` and disable all `Move [*] a space`
    - `Keyboard Shortcuts > Mission Control` and set all `Switch to Desktop [number]` to `ctrl + opt + cmd + [number]`
    - `Keyboard Shortcuts > Modifier Keys` and set `Caps Lock key` to `Escape`
    - `Keyboard` and set `Key repeat rate` to `Fast (MAX)`
    - `Keyboard` and set `Delay until repeat` to `Short (MAX)`
    - `Keyboard` and set `Press Globe key to` to `Show Emoji & Symbols`
    - `Appearance` and set `Allow wallpaper tinting in windows` to `OFF`
    - `Control Center` and set `Automatically hide and show the menu bar` to `Always`
    - `Sound` and set `Play feedback when volume is changed` to `ON`

- Setup SSH key
    - `ssh-keygen -t ed25519`

- Apps that need to be installed manually
    - Docker Desktop
    - KensingtonWorks (if using Kensington Trackball Mouse)

- Setup neovim config
    - https://github.com/fluxth/nvim-config
    - TODO: Add to automation script later
