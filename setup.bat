@echo off
REM Windows Development Environment Setup Batch File
REM This file automatically handles PowerShell execution policy and runs the setup

echo.
echo ===============================================
echo   Windows Development Environment Setup
echo ===============================================
echo.

REM Check if running as Administrator
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [INFO] Running with Administrator privileges - Good!
) else (
    echo [ERROR] This script must be run as Administrator!
    echo.
    echo Please:
    echo 1. Right-click on this file ^(setup.bat^)
    echo 2. Select "Run as administrator"
    echo 3. Click "Yes" when prompted
    echo.
    pause
    exit /b 1
)

echo.
echo [INFO] Setting PowerShell execution policy...

REM Set PowerShell execution policy to allow script execution
powershell -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force" >nul 2>&1

if %errorLevel% == 0 (
    echo [INFO] PowerShell execution policy set successfully
) else (
    echo [WARNING] Could not set execution policy automatically
    echo [INFO] Continuing with bypass method...
)

echo.
echo [INFO] Starting Windows setup script...
echo.

REM Run the PowerShell script with execution policy bypass
powershell -ExecutionPolicy Bypass -File "%~dp0windows-setup.ps1"

if %errorLevel% == 0 (
    echo.
    echo [SUCCESS] Windows setup completed successfully!
    echo.
    echo Next steps:
    echo 1. Restart your computer to complete WSL installation
    echo 2. After restart, open Windows Terminal and type 'wsl'
    echo 3. Copy the setup files to Ubuntu and run ubuntu-setup.sh
) else (
    echo.
    echo [ERROR] Setup script encountered an error (Exit Code: %errorLevel%)
    echo.
    echo Troubleshooting:
    echo - Make sure you're running as Administrator
    echo - Check your internet connection
    echo - Try running windows-setup.ps1 directly:
    echo   PowerShell -ExecutionPolicy Bypass -File windows-setup.ps1
)

echo.
echo Press any key to exit...
pause >nul