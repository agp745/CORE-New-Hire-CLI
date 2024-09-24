# CORE New Hire CLI

This CLI takes the ***IT Contact Information*** form and automatically populates the form.

## Usage

```powershell
$ NH -Name "<name>" -PW "<password>" [options] 
```

## REQUIRED FIELDS

-Name "<name>"

Specify the name of the new hire

-PW "<password>"

Specify the user's password

## Options

-Procedeo

If user is a Procedeo new hire, include this option which changes 2 things:
1. the email domain (@procedeogroup.com) 
2. the text color (procedeo yellow)

-Print

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
