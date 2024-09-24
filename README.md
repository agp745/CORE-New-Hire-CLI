# CORE New Hire CLI

This CLI takes the ***IT Contact Information*** form and automatically populates the fields.
> The CLI also creates a copy of the ***IT SUPPORT- Getting started*** email template, but does not populate those fields *YET*

## Usage

```powershell
$ NH -Name "<name>" -PW "<password>" [options] 
```

## REQUIRED FIELDS

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

1. Print options

Currently, the CLI can only Print to your default printer.  
I will add an option that will pull up a dialoug to change Printing options if desired. 

2. Pull ***IT Contact Information*** from cloud

Currently, the CLI uses my local version of the *Information form* which is not reflective of all useres.  
I am looking to change the CLI so that it copies the form from the Cloud and saves it locally to a temporary file or folder. 

3. Install Script

I am currently working out an install script that will make distribution of this CLI easy and seamless.
- **wget** and **scoop** support

4. Email template support

I am still debating if I should support the ***IT SUPPORT - Getting started*** email template.  
I need to see if the rest of the team uses that email template regularly.

5. Options for other companies (SVM)

Currently, only Procedeo is supported since that is the only other company I deal with new hires.
If this CLI is adopted by the whole team, I will add support for SVM
