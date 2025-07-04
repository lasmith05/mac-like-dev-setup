# Windows Dev Environment Setup Script
# Run this as Administrator in PowerShell

Write-Host "Setting up Windows Development Environment..." -ForegroundColor Green

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as Administrator!" -ForegroundColor Red
    Write-Host "Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Red
    exit 1
}

# Install WSL2 with Ubuntu 24.04 LTS
Write-Host "Installing WSL2 with Ubuntu 24.04 LTS..." -ForegroundColor Yellow
wsl --install -d Ubuntu-24.04

# Install Windows applications via winget
Write-Host "Installing Windows applications..." -ForegroundColor Yellow

# Visual Studio Code
Write-Host "Installing Visual Studio Code..." -ForegroundColor Cyan
winget install Microsoft.VisualStudioCode

# Git for Windows
Write-Host "Installing Git for Windows..." -ForegroundColor Cyan
winget install Git.Git

# Terraform
Write-Host "Installing Terraform..." -ForegroundColor Cyan
winget install HashiCorp.Terraform

# Windows Terminal (if not already installed)
Write-Host "Installing Windows Terminal..." -ForegroundColor Cyan
winget install Microsoft.WindowsTerminal

# Docker Desktop (optional but useful)
Write-Host "Installing Docker Desktop..." -ForegroundColor Cyan
winget install Docker.DockerDesktop

# Try to install Claude Code (may not be available yet)
Write-Host "Attempting to install Claude Code..." -ForegroundColor Cyan
try {
    winget install Anthropic.ClaudeCode
    Write-Host "Claude Code installed successfully!" -ForegroundColor Green
} catch {
    Write-Host "Claude Code not available via winget yet. Check Anthropic's documentation for manual installation." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Windows setup complete!" -ForegroundColor Green
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Restart your computer to complete WSL installation" -ForegroundColor White
Write-Host "2. Open Windows Terminal and run: wsl" -ForegroundColor White
Write-Host "3. Run the Ubuntu setup script in WSL" -ForegroundColor White
Write-Host "4. Download your dotfiles and ubuntu-setup.sh to your WSL home directory" -ForegroundColor White