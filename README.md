# dotfiles-macos

## Quick Start

Use the unified management script to install or update your dotfiles:

```bash
# Install everything
./manage.sh install

# Update everything
./manage.sh update

# Install specific components
./manage.sh install homebrew
./manage.sh install formulas
./manage.sh install omz

# Update specific components
./manage.sh update homebrew
./manage.sh update zsh-plugins
./manage.sh update dotfiles
```

For a full list of available commands and components, run:
```bash
./manage.sh
```

## Manual setup steps

- Go into `System Settings`
    - `Desktop & Dock` and set all `Hot Corners...` to `OFF`
    - `Desktop & Dock > Mission Control` and set `Automatically rearrange Spaces based on most recent use` to `OFF`
    - `Desktop & Dock > Desktop & Stage Manager` and set `Click wallpaper to reveal desktop` to `Only in Stage Manager`
    - `Keyboard Shortcuts > Mission Control` and disable all `Move * a space`
    - Add lots of desktops then:
        - `Keyboard Shortcuts > Mission Control` and set all `Switch to Desktop [number]` to `ctrl + opt + cmd + [number]`
    - `Keyboard Shortcuts > Modifier Keys` and set `Caps Lock key` to `Escape`
    - `Keyboard` and set `Key repeat rate` to `Fast (MAX)`
    - `Keyboard` and set `Delay until repeat` to `Short (MAX)`
    - `Keyboard` and set `Press Globe key to` to `Show Emoji & Symbols`
    - `Appearance` and set `Allow wallpaper tinting in windows` to `OFF`
    - `Control Center` and set `Automatically hide and show the menu bar` to `Always`

- Setup SSH key
    - `ssh-keygen -t ed25519`
