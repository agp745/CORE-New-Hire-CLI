$SourceURL = "https://raw.githubusercontent.com/agp745/CORE-New-Hire-CLI/refs/heads/main/newHire.ps1"
$DestinationDir = "$HOME\Documents\scripts"
$File = "$DestinationDir\newHireCLI.ps1"

# =======================
# Create dir and file
# =======================

if (-not (Test-Path $DestinationDir)) {
    Write-Host -ForegroundColor DarkGray "creating directory @ $DestinationDir"
    New-Item -ItemType Directory -Path $DestinationDir
}

if (-not (Test-Path $File)) {
    New-Item -ItemType File -Path $File
}

# =======================
# Write script to file
# =======================

Write-Host -ForegroundColor Yellow "downloading script...`n"
try {
    $response = Invoke-WebRequest -Uri "$SourceURL" -Method Get
    $response.Content > $File
} catch {
    Write-Host -ForegroundColor Red "error invoking web request to $SourceURL"
    return
}
Write-Host -ForegroundColor DarkGray "script downloaded`n"

# =======================
# Add alias to $PROFILE
# =======================

if (-not (Test-Path $PROFILE)) {
    try {
    $profileDir = Split-Path $PROFILE -Parent
    New-Item -ItemType Directory $profileDir -Force

    New-Item -ItemType File $PROFILE -Force
    } catch {
        Write-Host -ForegroundColor Red "Error: unable to create `$PROFILE"
        return
    }

    Write-Host -ForegroundColor DarkGray "`$PROFILE created @ $PROFILE"
}

Write-Host -ForegroundColor Yellow "editing `$PROFILE...`n"
try {
    $CLI_Alias = "`nSet-Alias NH '$File'"
    Add-Content -Path $PROFILE -Value $CLI_Alias
} catch {
    Write-Host -ForegroundColor Red "Error: unable to create alias to CLI.`nWrite to $PROFILE unsucessful."
}
Write-Host -ForegroundColor DarkGray "alias to CLI set in `$PROFILE`n"

Write-Host -ForegroundColor DarkGreen "New Hire CLI " -NoNewline
Write-Host -ForegroundColor Green "installed.`n" 

Write-Host -ForegroundColor Blue "[Usage]"
Write-Host -ForegroundColor White "NH -Name '<name>' -PW '<password>' [options]`n"
Write-Host -ForegroundColor DarkGray "Documentation: " -NoNewline
Write-Host -ForegroundColor "https://github.com/agp745/CORE-New-Hire-CLI"

