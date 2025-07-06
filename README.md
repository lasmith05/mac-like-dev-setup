# Mac-like Development Environment Setup

Automated setup scripts to recreate your complete development environment on any fresh Windows machine.

## 🚀 Quick Start

### 1. Download All Files

Create a new folder and download these files:
- `setup.bat` (Easy Windows setup - **recommended**)
- `windows-setup.ps1` (Windows setup script)
- `ubuntu-setup.sh` (Ubuntu setup script)
- `.tmux.conf` (tmux configuration)
- `.zshrc.custom` (zsh configuration)
- `.vimrc` (vim configuration)

### 2. Run Windows Setup

**Easy Method (Recommended):**
1. **Right-click on `setup.bat`**
2. **Select "Run as administrator"**
3. **Click "Yes"** when prompted
4. **Follow the on-screen instructions**

The batch file automatically handles PowerShell execution policy and runs the setup script.

**Alternative Method (PowerShell directly):**
1. **Run PowerShell as Administrator**
   - Right-click on PowerShell in Start menu
   - Select "Run as Administrator"
2. **Navigate to your setup folder**:
   ```powershell
   cd C:\path\to\your\setup\folder
   ```
3. **Run the Windows setup script**:
   ```powershell
   .\windows-setup.ps1
   ```

**If you get an execution policy error**, try:
```powershell
PowerShell -ExecutionPolicy Bypass -File .\windows-setup.ps1
```

This will install:
- WSL 2 with Ubuntu 24.04 LTS
- Visual Studio Code
- Git for Windows
- Terraform
- Windows Terminal
- Docker Desktop
- Claude Code (if available)

### 3. Restart Your Computer

After the Windows setup completes, restart your computer to complete WSL installation.

### 4. Run Ubuntu Setup

**Automated Method (Recommended):**
1. **Open Windows Terminal**
2. **Start WSL**: `wsl`
3. **Navigate to your setup folder**:
   ```bash
   cd /mnt/c/path/to/your/setup/folder
   ```
4. **Make the script executable and run it**:
   ```bash
   chmod +x ubuntu-setup.sh
   ./ubuntu-setup.sh
   ```

The script will automatically:
- Detect and copy dotfiles from your Windows folder
- Install all required packages and tools
- Configure your development environment

**Manual Method (if auto-detection fails):**
1. **Copy files manually**:
   ```bash
   cp /mnt/c/path/to/your/setup/folder/.* ~/
   ```
2. **Make script executable and run**:
   ```bash
   chmod +x ubuntu-setup.sh
   ./ubuntu-setup.sh
   ```

### 5. Final Steps

1. **Restart your terminal** to start using zsh
2. **Install tmux plugins**: Open tmux and press `Ctrl+a` then `Shift+I` (or `Ctrl+b` then `Shift+I` if config not loaded)
3. **Configure Git**:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```
4. **Install VS Code extensions** (recommended):
   - Markdown Preview Enhanced
   - Remote - WSL
   - GitLens
   - Terraform

## 🛠️ What Gets Installed

### Windows Applications
- **WSL 2** with Ubuntu 24.04 LTS
- **Visual Studio Code** - Primary editor
- **Git for Windows** - Version control
- **Terraform** - Infrastructure as code
- **Windows Terminal** - Modern terminal
- **Docker Desktop** - Containerization
- **Claude Code** - AI coding assistant (if available)

### Ubuntu/WSL Tools
- **tmux** - Terminal multiplexer with plugins
- **zsh + Oh My Zsh** - Modern shell with theming
- **Quality of life CLI tools**:
  - `eza` - Better ls with colors and icons
  - `bat` - Better cat with syntax highlighting
  - `ripgrep` - Fast text search
  - `fd` - Better find command
  - `fzf` - Fuzzy finder
- **Development tools**:
  - Git, Terraform, Node.js, Rust
  - Build tools and compilers

### tmux Configuration
- **Mouse support** - Click panes, drag to resize, scroll with wheel
- **Prefix changed** to `Ctrl+a` (more comfortable)
- **Plugins**:
  - Session persistence (survives reboots)
  - Copy to system clipboard
  - CPU/battery monitoring
  - Fuzzy finder integration
  - File sidebar
  - Quick text hints

### Shell Configuration
- **Aliases** for all quality of life tools
- **Git shortcuts** (gs, ga, gc, gp, etc.)
- **Terraform shortcuts** (tf, tfa, tfp, etc.)
- **Custom functions** for common tasks
- **fzf integration** for fuzzy searching

## 📝 Usage Examples

### Quality of Life Commands
```bash
# Beautiful file listing
ls          # eza with icons
ll          # detailed listing with git status
lt          # tree view

# Better text tools
cat file.py # syntax highlighted output
grep "text" # ripgrep with colors
find name   # fd with smart defaults

# Git shortcuts
gs          # git status
ga .        # git add .
gc "message" # git commit -m "message"
gp          # git push
gl          # git log --oneline --graph
```

### tmux Usage
```bash
# Start tmux
tmux

# Key bindings (prefix = Ctrl+a, fallback to Ctrl+b if config not loaded)
Ctrl+a c    # new window (or Ctrl+b c)
Ctrl+a |    # split vertically (or Ctrl+b |)
Ctrl+a -    # split horizontally (or Ctrl+b -)
Ctrl+a h/j/k/l  # navigate panes (vim style)

# Install tmux plugins
Ctrl+a Shift+I  # install plugins (or Ctrl+b Shift+I)

# If Ctrl+a doesn't work, your tmux config might not be loaded:
tmux kill-server  # kill all sessions
tmux              # start fresh
# Or manually reload: Ctrl+b : source-file ~/.tmux.conf

# Mouse support
# - Click to switch panes
# - Drag borders to resize
# - Scroll with mouse wheel
```

### Development Workflow
```bash
# Start development session
tmux new-session -s dev
cd your-project

# Split terminal for different tasks
Ctrl+a |    # split for editor
Ctrl+a -    # split for server/tests

# Session persists through reboots automatically
```

## 🔧 Customization

### Adding More Tools
Edit `ubuntu-setup.sh` to add more packages:
```bash
sudo apt install -y your-package-name
```

### Customizing Aliases
Edit `.zshrc.custom` to add your own aliases:
```bash
alias myalias='your-command'
```

### tmux Plugins
Add more plugins to `.tmux.conf`:
```bash
set -g @plugin 'plugin-name'
```

## 🆘 Troubleshooting

### Windows Setup Issues

**PowerShell Execution Policy Error:**
- **Use `setup.bat` instead** (recommended) - it handles this automatically
- Or if using PowerShell directly: `PowerShell -ExecutionPolicy Bypass -File .\windows-setup.ps1`
- Make sure you're running as Administrator

**Setup.bat not working:**
- Make sure you right-clicked and selected "Run as administrator"
- Check that all files are in the same folder
- Try the PowerShell method as alternative

### WSL Installation Issues

**Check WSL Status:**
```powershell
# Run in PowerShell as Administrator
wsl --list --verbose
wsl --status
```

**If WSL didn't install:**
1. **Enable Windows Features manually:**
   ```powershell
   dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
   dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
   ```
2. **Restart computer**
3. **Download WSL2 Linux kernel update** from Microsoft
4. **Set WSL2 as default:**
   ```powershell
   wsl --set-default-version 2
   ```
5. **Install Ubuntu:**
   ```powershell
   wsl --install -d Ubuntu-24.04
   # Or try: wsl --install Ubuntu
   ```

**If Ubuntu installed but won't start:**
- Open Windows Terminal and type `wsl`
- Or search for "Ubuntu" in Start menu
- Set up username/password when prompted

**Alternative Installation:**
- Install Ubuntu directly from Microsoft Store
- Search for "Ubuntu 24.04 LTS" in Microsoft Store

**Common Requirements:**
- Windows 10 version 2004+ or Windows 11
- Virtualization enabled in BIOS/UEFI
- At least 4GB free disk space

### Package Installation Fails
- Run `sudo apt update` first
- Check internet connection
- Try installing packages individually

### tmux Plugins Not Working
- Ensure TPM is installed: `ls ~/.tmux/plugins/tpm`
- Install plugins manually: `Ctrl+a` then `I`
- Restart tmux: `tmux kill-server` then `tmux`

### Claude Code Not Available
- Check Anthropic's documentation for latest installation instructions
- Try alternative installation methods (npm, direct download)
- Install manually when available

## 🚀 Repository Setup (Optional)

To make this fully automated, create a GitHub repository:

1. **Create repo**: `my-dev-setup`
2. **Upload all files**
3. **Clone and run**:
   ```bash
   git clone https://github.com/yourusername/my-dev-setup.git
   cd my-dev-setup
   # Follow setup instructions
   ```

## 🎉 Enjoy Your Mac-like Environment!

You now have a powerful, Mac-like development environment with:
- Modern terminal with multiplexing
- Quality of life CLI tools
- Persistent sessions
- Mouse support
- Syntax highlighting
- Fuzzy searching
- Git integration
- Modern shell with themes

Happy coding! 🚀