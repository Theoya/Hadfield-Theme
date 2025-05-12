# =============================================
# Hadfield Theme Builder
# =============================================
# This script builds and packages the Hadfield VS Code theme.
#
# Usage:
# 1. Open PowerShell in this directory
# 2. Run: .\build.ps1
#
# If you get a security error, run PowerShell as Administrator and execute:
# Set-ExecutionPolicy RemoteSigned
#
# The script will:
# - Install vsce if not already installed
# - Package the theme into a .vsix file
# - Automatically install the theme in VS Code
# - Show instructions for activating the theme
# =============================================

# Check if Node.js is installed
try {
    $nodeVersion = node --version
    Write-Host "Using Node.js version: $nodeVersion"
}
catch {
    Write-Host "Error: Node.js is not installed or not in PATH"
    Write-Host "Please install Node.js from https://nodejs.org/"
    exit 1
}

# Check if vsce is installed
$vsceInstalled = npm list -g @vscode/vsce
if (-not $vsceInstalled) {
    Write-Host "Installing vsce globally..."
    try {
        npm install -g @vscode/vsce
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to install vsce"
        }
    }
    catch {
        Write-Host "Error installing vsce: $_"
        Write-Host "Please try running: npm install -g @vscode/vsce manually"
        exit 1
    }
}

# Package the theme
Write-Host "Packaging the theme..."
try {
    # Use npx to run vsce, which will find it in the global installation
    npx @vscode/vsce package --allow-missing-repository --no-yarn
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to package theme"
    }
}
catch {
    Write-Host "Error packaging theme: $_"
    Write-Host "Please ensure you have Node.js and npm installed correctly"
    Write-Host "You can try running these commands manually:"
    Write-Host "1. npm install -g @vscode/vsce"
    Write-Host "2. npx @vscode/vsce package --allow-missing-repository --no-yarn"
    exit 1
}

# Get the latest .vsix file
$vsixFile = Get-ChildItem -Filter "*.vsix" | Sort-Object LastWriteTime -Descending | Select-Object -First 1

if ($vsixFile) {
    Write-Host "`nTheme packaged successfully: $($vsixFile.Name)"
    
    # Install the theme
    Write-Host "`nInstalling theme..."
    code --install-extension $vsixFile.FullName
    
    Write-Host "`nTheme installed successfully!"
    Write-Host "`nTo activate the theme:"
    Write-Host "1. Press Ctrl+Shift+P"
    Write-Host "2. Type 'Preferences: Color Theme'"
    Write-Host "3. Select 'Hadfield Dark' from the theme list"
} else {
    Write-Host "Error: Failed to create .vsix file"
    Write-Host "Please check if you have all required dependencies installed"
    exit 1
}

# Build script for Hadfield Theme
# This script copies the theme to VS Code's themes directory and restarts VS Code/Cursor if they're running

# Get the current script's directory
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path

# Define the VS Code themes directory
$vscodeThemesPath = "$env:APPDATA\Code\User\themes"

# Create the themes directory if it doesn't exist
if (-not (Test-Path $vscodeThemesPath)) {
    New-Item -ItemType Directory -Path $vscodeThemesPath -Force
}

# Copy the theme file
$themeFile = Join-Path $scriptPath "Hadfield_Theme.json"
Copy-Item -Path $themeFile -Destination $vscodeThemesPath -Force

Write-Host "Theme has been copied to VS Code themes directory"

# Function to restart VS Code/Cursor if running
function Restart-Editor {
    param (
        [string]$processName
    )
    
    $process = Get-Process $processName -ErrorAction SilentlyContinue
    if ($process) {
        Write-Host "Restarting $processName..."
        Stop-Process -Name $processName -Force
        Start-Sleep -Seconds 2
        Start-Process $processName
    }
}

# Restart VS Code if running
Restart-Editor "Code"

# Restart Cursor if running
Restart-Editor "Cursor"

Write-Host "Build complete! Theme has been installed and editors have been restarted if they were running." 