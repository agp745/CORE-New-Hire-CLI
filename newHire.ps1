param (
	[string]$Name,
	[string]$PW,
	[switch]$Procedeo,
	[switch]$Print
)

# ======================================
# Base variables
# ======================================

$User = $env:USERNAME

$CCGSourceDir = "C:\Users\$User\CCG Services, Inc\CORE Technology - Documents\IT\Communication"
$DestinationDir = "C:\Users\$User\OneDrive - CCG Services, Inc\Documents\NewHires"

$ContactInfoFile = "IT Contact Information.docx"
$EmailFile = "IT SUPPORT - Getting started.msg"

$hireName = $Name
$hirePW = $PW

# ======================================
# Validate input
# ======================================

if (-not $Name) {
    Write-Host -ForegroundColor DarkGray "`nname: " -NoNewline
    $hireName = Read-Host
}
if (-not $hireName) {
    Write-Host -ForegroundColor Red "Error: no name provided. use '-Name' to specify a name"
        return
}

if (-not $PW) {
    Write-Host -ForegroundColor DarkGray "password: " -NoNewline
    $hirePW = Read-Host
}
if (-not $hirePW) {
	Write-Host -ForegroundColor Red "Error: no password provided. use '-PW' to specify a password"
    return
}

if (-not $Print) {
    Write-Host -ForegroundColor DarkGray "do you want to print the document? [y/n]: " -NoNewline
    $res = Read-Host
	if ($res -eq "y" -or $res -eq "Y") {
		$Print = $true
	} elseif ($res -eq "n" -or $res -eq "N") {
	    $Print = $false
	} else {
		Write-Host -ForegroundColor Red "Invalid input. Please enter 'y' or 'n'."
        return
	}
}

# ======================================
# Check if destination dir exists
# ======================================

if (-not(Test-Path $DestinationDir -PathType Container)) {
    Write-Host -ForegroundColor DarkGray "`ncreating destination dir '$DestinationDir'..."
    New-Item -Path $DestinationDir -ItemType Directory
}

# ======================================
# Copy and Move file
# ======================================

try {
	Copy-Item -Path "$CCGSourceDir\$ContactInfoFile" -Destination "$destinationDir\$hireName.docx"
	Copy-Item -Path "$CCGSourceDir\$EmailFile" -Destination "$destinationDir\$hireName.msg"
} catch {
	Write-Error "Failed to copy & move files for $Name. File might already exist or is currently open."
	return
}

# =======================================
# Print validation
# =======================================

if ($Print) {
	$defaultPrinter = Get-WmiObject -Query "SELECT * FROM Win32_Printer WHERE Default=$true"
	$printerName = $defaultPrinter.Name
}

function printDoc {
	param (
		[string]$PrintWarning = "Do you wish to continue? [y/n]`n(select 'n' to edit print job)"
	)
	Write-Host -ForegroundColor DarkYellow "`nYou are about to print to " -NoNewLine
	Write-Host -ForegroundColor White "$printerName" -NoNewLine
	Write-Host -ForegroundColor DarkYellow "..."

	while ($true) {
		$response = Read-Host $PrintWarning
		if ($response -eq "y" -or $response -eq "Y") {
			Write-Host -ForegroundColor DarkGray "`nprocessing print job..."
			return $true
		} elseif ($response -eq "n" -or $response -eq "N") {
			Write-Host -ForegroundColor DarkGray "`npausing print job..."
			return $false
		} else {
			Write-Host "Invalid input. Please enter 'y' or 'n'."
		}
	}
}

if ($Print) {
    $isPrinting = printDoc #printDoc is invoked here to confirm print option BEFORE everything else is processed
}

# =======================================
# Edit word doc
# =======================================

$filePath = "$destinationDir\$hireName.docx"
$Word = New-Object -ComObject Word.Application
$Word.Visible = $true
$Document = $Word.Documents.Open($filePath)

$emailDomain

if ($Procedeo) { 
	$emailDomain = "@procedeogroup.com"
} else { 
	$emailDomain = "@coreconstruction.com"
}

function FillField {
	param (
		[string]$Field,
		[string]$Value
	)
	# Edit Value
	$val = $Value -replace '\s+'

	if ($Field -eq "Email:") {
		$val = $val.ToLower()
		$val += $emailDomain
	}

	# Find and Replace
	$range = $Document.Content
	$Find = $range.Find
	$Find.Text = $Field
	if ($Find.Execute()) {

		# Change the range
		$foundRange = $range.Duplicate
		$foundRange.Start = $foundRange.End
		$foundRange.End = $range.Paragraphs(1).Range.End

		# Append value and style
		$foundRange.Text = " $val`n"
		$foundRange.Font.Size = 14
		$foundRange.Font.Bold = $true
		if ($Procedeo) {
			$foundRange.Font.Color = 192 -bor (142 -shl 8) -bor (0 -shl 16) #yellow rgb(192,142,0)
		} else {
			$foundRange.Font.Color = 112 -bor (173 -shl 8) -bor (71 -shl 16) #green rgb(112,173,71)
		}
	} else {
		Write-Error "Field '$Field' not found."
		return
	}
	return
}

FillField -Field "Username:" -Value $hireName
FillField -Field "Email:" -Value $hireName
FillField -Field "Password" -Value $hirePW

$Document.Save()

# print document after document is processed 
if ($isPrinting -eq $true) {
	Write-Host -ForegroundColor Yellow "`nprinting..." 
	$Document.PrintOut()
} elseif ($Print -and -not $isPrinting) {
	Write-Host -ForegroundColor Yellow "`nopening print options..." 
	$Word.Dialogs.Item(88).Show() # opens print options
}
	

# =======================================
# optional - close the document & Word
# =======================================

# $Document.Close()
# $Word.Quit()

Write-Host -ForegroundColor Green "`nfiles for " -NoNewLine
Write-Host -ForegroundColor White "$hireName " -NoNewLine
Write-Host -ForegroundColor Green "saved at " -NoNewline
Write-Host -ForegroundColor White "$DestinationDir`n"
