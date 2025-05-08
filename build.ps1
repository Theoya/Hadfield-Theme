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

# Check if vsce is installed
$vsceInstalled = npm list -g @vscode/vsce
if (-not $vsceInstalled) {
    Write-Host "Installing vsce globally..."
    npm install -g @vscode/vsce
}

# Package the theme
Write-Host "Packaging the theme..."
vsce package --allow-missing-repository --no-yarn

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
} 