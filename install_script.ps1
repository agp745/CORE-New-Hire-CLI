$SourceURL = "https://raw.githubusercontent.com/agp745/CORE-New-Hire-CLI/refs/heads/main/newHire.ps1"
$DestinationURL = "$HOME\Documents\scripts\newHireCLI.ps1"

if (-not (Test-Path $DestinationURL)) {
    Write-Host -ForegroundColor DarkGray "creating directory @ $HOME\Documents\scripts ..."
    New-Item -ItemType File -Path $DestinationURL
}

$response = Invoke-WebRequest -Uri "$SourceURL" -Method Get

Write-Host -ForegroundColor Green "$response"
