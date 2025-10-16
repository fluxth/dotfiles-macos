#!/usr/bin/env bash -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ZSH plugins configuration
ZSH_PLUGINS=(
    "https://github.com/zsh-users/zsh-autosuggestions"
    "https://github.com/zsh-users/zsh-syntax-highlighting"
    "https://github.com/zsh-users/zsh-history-substring-search"
    "https://github.com/olets/zsh-abbr"
    "https://github.com/softmoth/zsh-vim-mode"
    "https://github.com/zsh-users/zsh-completions"
)

# Dotfiles directories to link/unlink
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

# Function to show usage
show_usage() {
    echo "Usage: $0 {install|update|link|unlink} [component]"
    echo ""
    echo "Commands:"
    echo "  install [component]  - Install components"
    echo "  update [component]   - Update components"
    echo "  link                 - Link dotfiles using stow"
    echo "  unlink               - Unlink dotfiles using stow"
    echo ""
    echo "Install components:"
    echo "  homebrew            - Install Homebrew"
    echo "  formulas            - Install brew formulas"
    echo "  formulas-work2025   - Install brew formulas (Work 2025 specific)"
    echo "  casks               - Install brew casks"
    echo "  wm                  - Install window manager tools (yabai, skhd, spacebar)"
    echo "  omz                 - Install Oh My Zsh"
    echo "  tpm                 - Install Tmux Plugin Manager"
    echo "  all                 - Install everything (default)"
    echo ""
    echo "Update components:"
    echo "  homebrew            - Update Homebrew"
    echo "  omz                 - Update Oh My Zsh"
    echo "  powerlevel10k       - Update Powerlevel10k theme"
    echo "  zsh-plugins         - Update all ZSH plugins"
    echo "  tpm                 - Update Tmux Plugin Manager"
    echo "  dotfiles            - Update this dotfiles repository"
    echo "  all                 - Update everything (default)"
}

# =============================================================================
# INSTALL FUNCTIONS
# =============================================================================

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
    for plugin in "${ZSH_PLUGINS[@]}"; do
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
    print_status "Run './manage.sh install <component>' to install these separately."
}

# =============================================================================
# UPDATE FUNCTIONS
# =============================================================================

# Function to update a git repository
update_repo() {
    local repo_path="$1"
    local repo_name="$2"

    if [[ ! -d "$repo_path" ]]; then
        print_warning "Repository not found: $repo_name at $repo_path"
        return 1
    fi

    if [[ ! -d "$repo_path/.git" ]]; then
        print_warning "Not a git repository: $repo_name at $repo_path"
        return 1
    fi

    print_status "Updating $repo_name..."

    cd "$repo_path" || {
        print_error "Failed to change directory to $repo_path"
        return 1
    }

    # Check if we're in a clean state
    if ! git diff-index --quiet HEAD --; then
        print_warning "$repo_name has uncommitted changes, skipping update"
        return 1
    fi

    # Fetch latest changes
    if git fetch origin >/dev/null 2>&1; then
        # Get current branch
        current_branch=$(git rev-parse --abbrev-ref HEAD)

        # Check if we're behind origin
        if git status --porcelain=v1 2>/dev/null | grep -q "^##.*behind"; then
            print_status "Pulling latest changes for $repo_name..."
            if git pull origin "$current_branch" >/dev/null 2>&1; then
                print_success "Updated $repo_name"
            else
                print_error "Failed to pull changes for $repo_name"
                return 1
            fi
        else
            print_success "$repo_name is already up to date"
        fi
    else
        print_error "Failed to fetch updates for $repo_name"
        return 1
    fi
}

# Function to update Homebrew
update_homebrew() {
    print_status "Updating Homebrew..."

    if command -v brew >/dev/null 2>&1; then
        if brew update >/dev/null 2>&1; then
            print_success "Homebrew updated successfully"

            # Check for outdated packages
            outdated_count=$(brew outdated | wc -l | tr -d ' ')
            if [[ "$outdated_count" -gt 0 ]]; then
                print_status "Found $outdated_count outdated package(s)"
                echo "Run 'brew upgrade' to upgrade them"
            else
                print_success "All Homebrew packages are up to date"
            fi
        else
            print_error "Failed to update Homebrew"
            return 1
        fi
    else
        print_warning "Homebrew not found, skipping update"
        return 1
    fi
}

# Function to update Powerlevel10k theme
update_powerlevel10k() {
    local p10k_path="$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
    update_repo "$p10k_path" "Powerlevel10k theme"
}

# Function to update ZSH plugins
update_zsh_plugins() {
    local plugins_dir="$HOME/.oh-my-zsh/custom/plugins"

    if [[ ! -d "$plugins_dir" ]]; then
        print_warning "ZSH plugins directory not found: $plugins_dir"
        return 1
    fi

    for plugin_url in "${ZSH_PLUGINS[@]}"; do
        local plugin_name=$(basename "$plugin_url")
        local plugin_path="$plugins_dir/$plugin_name"
        update_repo "$plugin_path" "ZSH plugin: $plugin_name"
    done
}

# Function to update Tmux Plugin Manager
update_tpm() {
    local tpm_path="$HOME/.local/share/tmux/plugins/tpm"
    update_repo "$tpm_path" "Tmux Plugin Manager"
}

# Function to update dotfiles repository (this repo)
update_dotfiles() {
    local dotfiles_path="$(dirname "$(readlink -f "$0" 2>/dev/null || echo "$0")")"
    update_repo "$dotfiles_path" "Dotfiles repository"
}

# Function to update Oh My Zsh core
update_omz() {
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        if command -v omz >/dev/null 2>&1; then
            print_status "Updating Oh My Zsh..."
            if omz update >/dev/null 2>&1; then
                print_success "Oh My Zsh updated successfully"
            else
                print_error "Failed to update Oh My Zsh"
                return 1
            fi
        else
            # Fallback to manual update
            update_repo "$HOME/.oh-my-zsh" "Oh My Zsh"
        fi
    else
        print_warning "Oh My Zsh not found, skipping update"
        return 1
    fi
}

# Function to update everything
update_all() {
    print_status "Starting update process..."
    echo

    # Store original directory
    original_dir="$(pwd)"

    # Update Homebrew first
    update_homebrew
    echo

    # Update Oh My Zsh
    update_omz
    echo

    # Update Powerlevel10k theme
    update_powerlevel10k
    echo

    # Update ZSH plugins
    update_zsh_plugins
    echo

    # Update Tmux Plugin Manager
    update_tpm
    echo

    # Update dotfiles repository
    update_dotfiles
    echo

    # Return to original directory
    cd "$original_dir" || exit 1

    print_success "Update process completed!"
    echo
    print_status "Note: You may need to restart your shell or source your configuration files"
    print_status "to see the changes take effect."
}

# Function to link dotfiles
link_dotfiles() {
    print_status "Linking dotfiles..."

    for dir in "${LINK_DIRS[@]}"; do
        print_status "Linking \"$dir\""
        if stow "$dir"; then
            print_success "Successfully linked $dir"
        else
            print_error "Failed to link $dir"
        fi
    done

    print_success "Dotfiles linking completed!"
}

# Function to unlink dotfiles
unlink_dotfiles() {
    print_status "Unlinking dotfiles..."

    for dir in "${LINK_DIRS[@]}"; do
        print_status "Unlinking \"$dir\""
        if stow -D "$dir"; then
            print_success "Successfully unlinked $dir"
        else
            print_error "Failed to unlink $dir"
        fi
    done

    print_success "Dotfiles unlinking completed!"
}

# =============================================================================
# MAIN SCRIPT LOGIC
# =============================================================================

# Check if at least one argument is provided
if [[ $# -eq 0 ]]; then
    show_usage
    exit 1
fi

# Get the command (install or update)
command="$1"
shift

# Handle the command
case "$command" in
    install)
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
                echo "Unknown install component: $1"
                echo ""
                echo "Available install components:"
                echo "  homebrew, formulas, formulas-work2025, casks, wm, omz, tpm, all"
                exit 1
                ;;
        esac
        ;;
    update)
        case "${1:-all}" in
            homebrew)
                update_homebrew
                ;;
            omz)
                update_omz
                ;;
            powerlevel10k|p10k)
                update_powerlevel10k
                ;;
            zsh-plugins|plugins)
                update_zsh_plugins
                ;;
            tpm|tmux)
                update_tpm
                ;;
            dotfiles)
                update_dotfiles
                ;;
            all)
                update_all
                ;;
            *)
                echo "Unknown update component: $1"
                echo ""
                echo "Available update components:"
                echo "  homebrew, omz, powerlevel10k, zsh-plugins, tpm, dotfiles, all"
                exit 1
                ;;
        esac
        ;;
    link)
        link_dotfiles
        ;;
    unlink)
        unlink_dotfiles
        ;;
    *)
        echo "Unknown command: $command"
        echo ""
        show_usage
        exit 1
        ;;
esac
