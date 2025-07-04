#!/bin/bash
# Ubuntu Development Environment Setup Script
# Run this inside WSL Ubuntu

set -e  # Exit on any error

echo "🚀 Setting up Ubuntu Development Environment..."

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

# Set up dotfiles
echo "📝 Setting up dotfiles..."

# Only copy dotfiles if they don't exist (don't overwrite existing configs)
if [ ! -f "$HOME/.tmux.conf" ]; then
    cp .tmux.conf ~/.tmux.conf 2>/dev/null || echo "⚠️  .tmux.conf not found - will need to be created manually"
fi

if [ ! -f "$HOME/.zshrc.custom" ]; then
    cp .zshrc.custom ~/.zshrc.custom 2>/dev/null || echo "⚠️  .zshrc.custom not found - will need to be created manually"
fi

if [ ! -f "$HOME/.vimrc" ]; then
    cp .vimrc ~/.vimrc 2>/dev/null || echo "⚠️  .vimrc not found - will need to be created manually"
fi

# Add custom zsh config to .zshrc
if [ -f "$HOME/.zshrc.custom" ]; then
    echo "" >> ~/.zshrc
    echo "# Custom configuration" >> ~/.zshrc
    echo "source ~/.zshrc.custom" >> ~/.zshrc
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
echo "📋 Next steps:"
echo "1. Exit and restart your terminal to use zsh"
echo "2. In tmux, press Ctrl+b then I to install plugins (if not already done)"
echo "3. Test your new tools:"
echo "   - ls (should show eza with colors)"
echo "   - ll (should show detailed listing)"
echo "   - cat ~/.zshrc (should show syntax highlighting)"
echo "   - tmux (should start with all plugins)"
echo ""
echo "🛠️  Manual steps needed:"
echo "1. Install Claude Code from Anthropic's documentation"
echo "2. Configure VS Code extensions"
echo "3. Set up your Git credentials: git config --global user.name 'Your Name'"
echo "                                git config --global user.email 'your.email@example.com'"
echo ""
echo "Enjoy your new Mac-like development environment! 🚀"