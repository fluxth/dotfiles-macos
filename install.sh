#!/usr/bin/env bash -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to install Homebrew
install_homebrew() {
    print_status "Installing Homebrew..."
    if bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
        print_success "Homebrew installation complete"
    else
        print_error "Homebrew installation failed"
        return 1
    fi
}

# Function to install brew formulas
install_formulas() {
    print_status "Installing brew formulas..."
    if brew install \
        bash \
        binutils \
        docker \
        eza \
        fzf \
        gh \
        git \
        git-delta \
        git-gui \
        jq \
        mpv \
        neovim \
        node \
        ripgrep \
        rustup \
        stow \
        telnet \
        thefuck \
        tmux \
        watch \
        zsh; then
        print_success "Brew formulas installation complete"
    else
        print_error "Brew formulas installation failed"
        return 1
    fi
}

# Function to install brew formulas (Work 2025 specific)
install_formulas_work2025() {
    print_status "Installing brew formulas (Work 2025 specific)..."
    if brew install \
        uv \
        buf \
        cmake \
        go \
        gopls \
        grpcui \
        grpcurl \
        mingw-w64 \
        mise \
        oci-cli \
        protobuf; then
        print_success "Brew formulas (Work 2025 specific) installation complete"
    else
        print_error "Brew formulas (Work 2025 specific) installation failed"
        return 1
    fi
}

# Function to install brew casks
install_casks() {
    print_status "Installing brew casks..."
    if brew install --cask \
        alacritty \
        font-meslo-lg-nerd-font \
        font-fontawesome \
        karabiner-elements; then
        print_success "Brew casks installation complete"
    else
        print_error "Brew casks installation failed"
        return 1
    fi
}

# Function to install window manager tools
install_wm() {
    print_status "Installing window manager tools (yabai, skhd, spacebar)..."
    if brew install \
        cmacrae/formulae/spacebar \
        koekeishiya/formulae/skhd \
        koekeishiya/formulae/yabai; then
        print_success "Window manager tools installation complete"
        echo
        print_warning "Manual configuration required for yabai!"
        print_status "Please follow the manual steps at:"
        echo -e "${BLUE}https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release)${NC}"
        print_status "Key steps:"
        print_status "  1. Grant accessibility permissions in System Settings"
        print_status "  2. Configure scripting addition (if SIP is disabled)"
        print_status "  3. Start services with:"
        print_status "     yabai --start-service"
        print_status "     skhd --start-service"
        print_status "     brew services start spacebar"
    else
        print_error "Window manager tools installation failed"
        return 1
    fi
}

# Function to install Oh My Zsh
install_omz() {
    print_status "Installing Oh My Zsh..."
    if bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --keep-zshrc --unattended"; then
        print_success "Oh My Zsh installation complete"
    else
        print_error "Oh My Zsh installation failed"
        return 1
    fi

    print_status "Installing Powerlevel10k theme..."
    mkdir -p "$HOME/.oh-my-zsh/custom/themes"
    if git clone https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"; then
        print_success "Powerlevel10k theme installation complete"
    else
        print_error "Powerlevel10k theme installation failed"
        return 1
    fi

    print_status "Installing ZSH plugins..."
    mkdir -p "$HOME/.oh-my-zsh/custom/plugins"

    # Install ZSH plugins
    plugins=(
        "https://github.com/zsh-users/zsh-autosuggestions"
        "https://github.com/zsh-users/zsh-syntax-highlighting"
        "https://github.com/zsh-users/zsh-history-substring-search"
        "https://github.com/olets/zsh-abbr"
        "https://github.com/softmoth/zsh-vim-mode"
        "https://github.com/zsh-users/zsh-completions"
    )

    for plugin in "${plugins[@]}"; do
        plugin_name=$(basename "$plugin")
        print_status "Installing ZSH plugin: $plugin_name"
        if git clone --recurse-submodules "$plugin" "$HOME/.oh-my-zsh/custom/plugins/$plugin_name"; then
            print_success "ZSH plugin $plugin_name installed successfully"
        else
            print_error "Failed to install ZSH plugin: $plugin_name"
        fi
    done

    print_success "ZSH plugins installation complete"
}

# Function to install Tmux Plugin Manager
install_tpm() {
    print_status "Installing tmux plugin manager..."
    mkdir -p "$HOME/.local/share/tmux/plugins"
    if git clone https://github.com/tmux-plugins/tpm "$HOME/.local/share/tmux/plugins/tpm"; then
        print_success "Tmux plugin manager installation complete"
    else
        print_error "Tmux plugin manager installation failed"
        return 1
    fi
}

# Function to install everything
install_all() {
    print_status "Starting full installation..."
    echo

    install_homebrew
    echo

    install_formulas
    echo

    install_omz
    echo

    install_tpm
    echo

    install_casks
    echo

    print_success "All installations complete!"
    echo
    print_status "Please restart your terminal or source your shell configuration files"
    print_status "to start using the new tools and configurations."
    echo
    print_warning "Optional components not installed by default:"
    print_status "  - formulas-work2025: Work-specific brew formulas"
    print_status "  - wm: Window manager tools (yabai, skhd, spacebar)"
    print_status "Run './install.sh <component>' to install these separately."
}

# Main script logic
case "${1:-all}" in
    homebrew)
        install_homebrew
        ;;
    formulas)
        install_formulas
        ;;
    formulas-work2025)
        install_formulas_work2025
        ;;
    casks)
        install_casks
        ;;
    wm)
        install_wm
        ;;
    omz)
        install_omz
        ;;
    tpm)
        install_tpm
        ;;
    all)
        install_all
        ;;
    *)
        echo "Usage: $0 {homebrew|formulas|formulas-work2025|casks|wm|omz|tpm|all}"
        echo ""
        echo "Installed by default (with 'all'):"
        echo "  homebrew            - Install Homebrew"
        echo "  formulas            - Install brew formulas"
        echo "  casks               - Install brew casks"
        echo "  omz                 - Install Oh My Zsh"
        echo "  tpm                 - Install Tmux Plugin Manager"
        echo "  all                 - Install everything (default)"
        echo ""
        echo "Optional components:"
        echo "  formulas-work2025   - Install brew formulas (Work 2025 specific)"
        echo "  wm                  - Install window manager tools (yabai, skhd, spacebar)"
        exit 1
        ;;
esac
