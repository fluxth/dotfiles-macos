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

    local plugins=(
        "zsh-autosuggestions"
        "zsh-syntax-highlighting"
        "zsh-history-substring-search"
        "zsh-abbr"
        "zsh-vim-mode"
        "zsh-completions"
    )

    for plugin in "${plugins[@]}"; do
        local plugin_path="$plugins_dir/$plugin"
        update_repo "$plugin_path" "ZSH plugin: $plugin"
    done
}

# Function to update Tmux Plugin Manager
update_tpm() {
    local tpm_path="$HOME/.local/share/tmux/plugins/tpm"
    update_repo "$tpm_path" "Tmux Plugin Manager"
}

# Function to update dotfiles repository (this repo)
update_dotfiles() {
    local dotfiles_path="$(dirname "$(realpath "$0")")"
    update_repo "$dotfiles_path" "Dotfiles repository"
}

# Function to update Oh My Zsh core
update_omz() {
    print_status "Updating Oh My Zsh..."

    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        if command -v omz >/dev/null 2>&1; then
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

# Main script logic
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
        echo "Usage: $0 {homebrew|omz|powerlevel10k|zsh-plugins|tpm|dotfiles|all}"
        echo "  homebrew     - Update Homebrew"
        echo "  omz          - Update Oh My Zsh"
        echo "  powerlevel10k - Update Powerlevel10k theme"
        echo "  zsh-plugins  - Update all ZSH plugins"
        echo "  tpm          - Update Tmux Plugin Manager"
        echo "  dotfiles     - Update this dotfiles repository"
        echo "  all          - Update everything (default)"
        exit 1
        ;;
esac
