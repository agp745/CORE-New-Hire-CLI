param (
	[string]$Name,
	[string]$PW,
	[switch]$Procedeo,
	[switch]$Print
)

# util variables
$boldStart = "`e[1m"
$boldEnd = "`e[0m"

$sourceDir = "C:\Users\AlejandroPerez\OneDrive - CCG Services, Inc\Documents\Onboarding"
$destinationDir = "C:\Users\AlejandroPerez\OneDrive - CCG Services, Inc\Documents\Onboarding\NewHires"

$contactInfoFile = "IT Contact Information.docx"
$emailFile = "IT SUPPORT - Getting started.msg"

if (-not $Name) {
	Write-Output "No name provided. Please provide a name"
}

# Copy and Move file
try {
	Copy-Item -Path "$sourceDir\$contactInfoFile" -Destination "$destinationDir\$Name.docx"
	Copy-Item -Path "$sourceDir\$emailFile" -Destination "$destinationDir\$Name.msg"
} catch {
	Write-Error "Failed to copy & move files for $Name. File might already exist or is currently open."
	return
}

# Print validation
if ($Print) {
	$defaultPrinter = Get-WmiObject -Query "SELECT * FROM Win32_Printer WHERE Default=$true"
	$printerName = $defaultPrinter.Name
}

function printDoc {
	param (
		[string]$PrintMessage = "You are about to print to $printerName. Do you wish to continue? [y/n]"
	)

	while ($true) {
		$response = Read-Host $PrintMessage
		if ($response -eq "y" -or $response -eq "Y") {
			Write-Output "processing print job..."
			return $true
		} elseif ($response -eq "n" -or $response -eq "N") {
			Write-Output "canceling print job..."
			return $false
		} else {
			Write-Host "Invalid input. Please enter 'y' or 'n'."
		}
	}
}

$isPrinting = printDoc #printDoc is invoked here to confirm print option BEFORE everything else is processed

# Edit word doc

$filePath = "$destinationDir\$Name.docx"
$Word = New-Object -ComObject Word.Application
$Word.Visible = $true
$Document = $Word.Documents.Open($filePath)

$emailDomain

if ($Procedeo) { 
	$emailDomain = "@procedeogroup.com"
} else { 
	$emailDomain = "@coreconstruction.com"
}

function Fill-Field {
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

Fill-Field -Field "Username:" -Value $Name
Fill-Field -Field "Email:" -Value $Name
Fill-Field -Field "Password" -Value $PW

$Document.Save()
# print document after document is processed 
if ($isPrinting -eq $true) {
	Write-Host "printing..." -ForegroundColor Yellow
	$Document.PrintOut()
}

# optional document & word close
# $Document.Close()
# $Word.Quit()

# Write-Host "Files for $Name created successfully!`n"
Write-Host -ForegroundColor Green "files for " -NoNewLine
Write-Host -ForegroundColor White "$Name " -NoNewLine
Write-Host -ForegroundColor Green "created sucessfully!"

