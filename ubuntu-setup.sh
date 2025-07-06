#!/bin/bash
# Ubuntu Development Environment Setup Script
# Run this inside WSL Ubuntu

set -e  # Exit on any error

echo "🚀 Setting up Ubuntu Development Environment..."

# Function to auto-detect setup files from Windows
find_setup_files() {
    local possible_paths=(
        "/mnt/c/dev-setup"
        "/mnt/c/Downloads"
        "/mnt/c/Users/$USER/Downloads" 
        "/mnt/c/Users/$USER/Desktop"
        "/mnt/c/Users/$USER/Documents"
        "$(pwd)"  # Current directory
    )
    
    echo "🔍 Auto-detecting setup files..."
    
    for path in "${possible_paths[@]}"; do
        if [ -f "$path/.tmux.conf" ] && [ -f "$path/.vimrc" ] && [ -f "$path/.zshrc.custom" ]; then
            echo "✅ Found setup files in: $path"
            echo "📁 Copying dotfiles to home directory..."
            
            # Copy dotfiles to home directory
            cp "$path/.tmux.conf" "$HOME/" 2>/dev/null || echo "⚠️  Could not copy .tmux.conf"
            cp "$path/.vimrc" "$HOME/" 2>/dev/null || echo "⚠️  Could not copy .vimrc" 
            cp "$path/.zshrc.custom" "$HOME/" 2>/dev/null || echo "⚠️  Could not copy .zshrc.custom"
            
            echo "✅ Dotfiles copied successfully"
            return 0
        fi
    done
    
    echo "⚠️  Could not auto-detect setup files."
    echo "📝 Please ensure the following files are in your home directory:"
    echo "   - .tmux.conf"
    echo "   - .vimrc" 
    echo "   - .zshrc.custom"
    echo ""
    echo "💡 You can copy them manually with:"
    echo "   cp /mnt/c/path/to/your/setup/files/.* ~/"
    echo ""
    read -p "Press Enter to continue if files are already in place, or Ctrl+C to exit..."
    return 1
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to verify file exists and is readable
verify_file() {
    if [ -f "$1" ] && [ -r "$1" ]; then
        echo "✅ $1 exists and is readable"
        return 0
    else
        echo "❌ $1 is missing or not readable"
        return 1
    fi
}

# Check if we're in WSL
if ! grep -q Microsoft /proc/version 2>/dev/null; then
    echo "⚠️  This script is designed for WSL. Continue anyway? (y/n)"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Auto-detect and copy setup files from Windows
find_setup_files

# Update system
echo "📦 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install essential development tools
echo "🔧 Installing essential development tools..."
sudo apt install -y \
    tmux \
    zsh \
    git \
    curl \
    wget \
    build-essential \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    unzip

# Install quality of life CLI tools
echo "✨ Installing quality of life CLI tools..."
sudo apt install -y \
    eza \
    ripgrep \
    fd-find \
    fzf \
    bat

# Create bat symlink (Ubuntu installs it as batcat)
sudo ln -sf /usr/bin/batcat /usr/local/bin/bat

# Install Terraform
echo "🏗️ Installing Terraform..."
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install terraform

# Install Node.js and npm (useful for development)
echo "🟢 Installing Node.js and npm..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

# Install Oh My Zsh
echo "🐚 Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install TPM (Tmux Plugin Manager)
echo "🔌 Installing Tmux Plugin Manager..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install Rust and Cargo (for some modern tools)
echo "🦀 Installing Rust and Cargo..."
if ! command -v rustc &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source ~/.cargo/env
fi

# Set up dotfiles with proper line endings
echo "📝 Setting up dotfiles..."

# Function to backup existing file if it exists
backup_existing_file() {
    local file="$1"
    
    if [ -f "$file" ]; then
        local backup_file="${file}.backup.$(date +%Y-%m-%d-%H%M%S)"
        cp "$file" "$backup_file"
        echo "📄 Backed up existing $file to $backup_file"
        return 0
    fi
    return 1
}

# Function to ensure dotfile has proper Unix line endings
ensure_unix_line_endings() {
    local file="$1"
    
    if [ -f "$file" ]; then
        echo "📄 Processing $file for Unix line endings..."
        
        # Create temporary file with Unix line endings
        local temp_file="${file}.tmp"
        tr -d '\r' < "$file" > "$temp_file"
        
        # Replace original with cleaned version
        mv "$temp_file" "$file"
        echo "✅ $file updated with Unix line endings"
    else
        echo "⚠️  $file not found, skipping line ending conversion"
    fi
}

# Ensure dotfiles have proper Unix line endings
ensure_unix_line_endings ~/.tmux.conf
ensure_unix_line_endings ~/.vimrc  
ensure_unix_line_endings ~/.zshrc.custom

# Verify dotfiles were created
echo "🔍 Verifying dotfiles..."
verify_file ~/.tmux.conf || echo "⚠️  .tmux.conf not created"
verify_file ~/.vimrc || echo "⚠️  .vimrc not created"
verify_file ~/.zshrc.custom || echo "⚠️  .zshrc.custom not created"

# Add custom zsh config to .zshrc
if [ -f "$HOME/.zshrc.custom" ]; then
    # Check if custom config is already sourced to prevent duplicates
    if ! grep -q "source ~/.zshrc.custom" ~/.zshrc 2>/dev/null; then
        # Backup .zshrc before modifying
        backup_existing_file ~/.zshrc
        
        echo "" >> ~/.zshrc
        echo "# Custom configuration" >> ~/.zshrc
        echo "source ~/.zshrc.custom" >> ~/.zshrc
        echo "✅ Added custom zsh configuration to .zshrc"
    else
        echo "📄 Custom zsh configuration already present in .zshrc"
    fi
fi

# Set zsh as default shell
echo "🐚 Setting zsh as default shell..."
sudo chsh -s $(which zsh) $USER

# Install tmux plugins
echo "🔌 Installing tmux plugins..."
if [ -f "$HOME/.tmux.conf" ]; then
    # Start tmux in detached mode and install plugins
    tmux new-session -d -s setup
    tmux send-keys -t setup "~/.tmux/plugins/tpm/bin/install_plugins" Enter
    sleep 5
    tmux kill-session -t setup
fi

echo ""
echo "🎉 Ubuntu development environment setup complete!"
echo ""
echo "🔍 Final verification:"

# Verify installations
echo "📦 Checking installed packages..."
command_exists tmux && echo "✅ tmux installed" || echo "❌ tmux missing"
command_exists zsh && echo "✅ zsh installed" || echo "❌ zsh missing"
command_exists git && echo "✅ git installed" || echo "❌ git missing"
command_exists eza && echo "✅ eza installed" || echo "❌ eza missing"
command_exists bat && echo "✅ bat installed" || echo "❌ bat missing"
command_exists rg && echo "✅ ripgrep installed" || echo "❌ ripgrep missing"
command_exists fd && echo "✅ fd installed" || echo "❌ fd missing"
command_exists fzf && echo "✅ fzf installed" || echo "❌ fzf missing"

# Verify dotfiles
echo ""
echo "📄 Checking dotfiles..."
verify_file ~/.tmux.conf
verify_file ~/.vimrc
verify_file ~/.zshrc.custom

# Check if Oh My Zsh is installed
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "✅ Oh My Zsh installed"
else
    echo "❌ Oh My Zsh missing"
fi

# Check if TPM is installed
if [ -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "✅ Tmux Plugin Manager installed"
else
    echo "❌ Tmux Plugin Manager missing"
fi

# Check if custom config is loaded in .zshrc
if grep -q "source ~/.zshrc.custom" ~/.zshrc 2>/dev/null; then
    echo "✅ Custom zsh config is linked"
else
    echo "⚠️  Custom zsh config not linked in .zshrc"
fi

echo ""
echo "📋 Next steps:"
echo "1. 🔄 Restart your terminal to use zsh as default shell"
echo "2. 🔌 Open tmux and press Ctrl+a then I to install plugins"
echo "3. 🔧 Configure Git credentials:"
echo "   git config --global user.name 'Your Name'"
echo "   git config --global user.email 'your.email@example.com'"
echo "4. 🧪 Test your setup:"
echo "   ls    # Should show colorful output with icons"
echo "   cat ~/.bashrc  # Should show syntax highlighting"
echo "   tmux  # Should start with mouse support"
echo ""
echo "📁 Backup Information:"
echo "   Any existing dotfiles were backed up with .backup.[timestamp] extension"
echo "   To restore a backup: mv ~/.vimrc.backup.[timestamp] ~/.vimrc"
echo "   To see backups: ls -la ~ | grep backup"
echo ""
echo "🛠️  If any items show ❌, you may need to run parts of the setup manually."
echo "🎯  For issues, check the GitHub repository README for troubleshooting."
echo ""
echo "Enjoy your new Mac-like development environment! 🚀"
