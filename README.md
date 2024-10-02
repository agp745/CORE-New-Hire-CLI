# CORE New Hire CLI

This CLI takes the ***IT Contact Information*** form and automatically populates the fields.
> The CLI also creates a copy of the ***IT SUPPORT- Getting started*** email template, but does not populate those fields *YET*

## Installation

Paste the following code into powershell

```powershell
curl -o tempInstall.ps1 https://raw.githubusercontent.com/agp745/CORE-New-Hire-CLI/refs/heads/main/install_script.ps1; .\tempInstall.ps1; Remove-Item tempInstall.ps1
```

## Usage

```powershell
> NH -Name "<name>" -PW "<password>" [options] 
```
> Invoking **NH** without *-Name* and/or *-PW* and/or *-Print* will prompt the user to validate those fields.  
> Leaving *-Name* or *-PW* fields empty after validation will throw an error

```powershell
> NH

name: Alejandro Perez
password: TestPassword1937
do you want to print the document? [y/n]: y
```

## Fields

### -Name "&lt;name&gt;"

Specify the name of the new hire

### -PW "&lt;password&gt;"

Specify the user's password

## Options

### -Procedeo

If user is a Procedeo new hire, include this option which changes 2 things:
1. the email domain (@procedeogroup.com) 
2. the text color (procedeo yellow)

### -Print

Will automatically print the document to your default printer.  
> Before the document processes, you will be prompted to confirm if you want to print to the default printer


## Features to add

1. Email template support

I am still debating if I should support the ***IT SUPPORT - Getting started*** email template.  
I need to see if the rest of the team uses that email template regularly.

2. Options for other companies (SVM)

Currently, only Procedeo is supported since that is the only other company I deal with new hires.
If this CLI is adopted by the whole team, I will add support for SVM
