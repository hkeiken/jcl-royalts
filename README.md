# jcl-royalts-import.ps1

Small Powershell script using [RoyalDocument.PowerShell module](https://support.royalapps.com/support/solutions/articles/17000027865-royal-ts-powershell-module-introduction) to create a RoyalTS / RoyalTSX document from a JCS CSV file with credentials. Two folders, Private and Public is created to store objects for both internal and external destination addresses.

## Install what is needed

### Installation of PowerShell on MacOS:
Install [Brew](https://brew.sh/):

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

Use Brew to [install PowerShell]( https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-macos?view=powershell-7 ):

```
brew cask install powershell
```

### Installation of [PowerShell on linux distribution Debian 10/Buster](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-7 ):
```
wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y powershell
pwsh
```

## Installation of [RoyalDocument.PowerShell]( https://support.royalapps.com/support/solutions/articles/17000027865-royal-ts-powershell-module-introduction ):
```
Import-Module "${env:ProgramFiles(x86)}\code4ward.net\Royal TS V4\RoyalDocument.PowerShell.dll"
```

## How to use:

```
jcl-royalts-import.ps1 -inputfile input.csv -outputfile output.rtsz
```


## Known issues:

Tested on OSX and Linux using version 5.2.60224 of the RoyalDocument.PowerShell module. In this version an error message seen below is observed, but this has no impact on the function:

```
PS /root> ./jcl-royalts-import.ps1
New-RoyalStore: /root/jcl-royalts-import.ps1:105
Line |
105 |  $store = New-RoyalStore -UserName "JCL"
     |           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     | The method or operation is not implemented.
```
