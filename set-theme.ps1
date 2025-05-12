# Set VS Code theme to Hadfield Dark
$settingsPath = "$env:APPDATA\Code\User\settings.json"

# Create settings.json if it doesn't exist
if (-not (Test-Path $settingsPath)) {
    Set-Content -Path $settingsPath -Value "{}"
}

# Read current settings
$settings = Get-Content $settingsPath | ConvertFrom-Json

# Add or update the theme setting
$settings | Add-Member -NotePropertyName "workbench.colorTheme" -NotePropertyValue "Hadfield Dark" -Force

# Save the settings
$settings | ConvertTo-Json | Set-Content $settingsPath

Write-Host "Theme set to Hadfield Dark. Please reload VS Code to see the changes." 