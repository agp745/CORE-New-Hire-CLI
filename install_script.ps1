$SourceURL = "https://raw.githubusercontent.com/agp745/CORE-New-Hire-CLI/refs/heads/main/newHire.ps1"
$DestinationDir = "$HOME\Documents\scripts\"

if (-not (Test-Path $DestinationDir)) {
    Write-Host -ForegroundColor DarkGray "creating directory @ $DestinationDir"
    New-Item -ItemType Directory -Path $DestinationDir
}

New-Item -ItemType File -Path "$DestinationDir\newHireCLI.ps1"

$response = Invoke-WebRequest -Uri "$SourceURL" -Method Get

Write-Host -ForegroundColor Green "$response"
