# Quick and dirty first PowerShell script to import a csv file from JCL to a
# RoyalTS / RoyalTSX document to ease use of JCS as one no longer
# will have to manually enter all credentials into RoyalTSX

<#
.SYNOPSIS
    Script to create RoyalTS document from a JCL csv file
.DESCRIPTION
    JCL is a Juniper internal system for lab management. Some parts
    are available to registered non Juniper employees. When
    using this system today the system attaches a csv file with lab
    server information like ip addresses, ports and credentials. To ease
    the usage of JCL this script was made. It creates two folders in
    the RoyalTS document: Private for access using private addresses and
    Public for external access.
.PARAMETER inputfile
    The path to the input csv file that comes from JCL when initiating a lab
.PARAMETER outputfile
    The path to the RoyalTS document created
.EXAMPLE
    pwsh jcl-royalts-import -inputfile jcl.csv -outputfile jcl.rtsx

    This imports a csv file from JCL and creates a RoyalTS Document
.NOTES
    Author: Hans Kristian Eiken
    Email: hans@eikjen.no
    Date:  2020-06-23
#>

param (
    [string]$inputfile = "JCL-Sandbox-Resources.csv",
    [string]$outputfile = "JCL-Sandbox-Resources.rtsx"
)

Import-Module RoyalDocument.PowerShell

#Function copied form https://www.powershellgallery.com/packages/RoyalDocument.PowerShell example
function CreateRoyalFolderHierarchy() {
  param(
    [string]$folderStructure,
    [string]$splitter,
  $Folder
    )
  $currentFolder = $Folder

  $folderStructure -split $splitter | %{
    $folder = $_
    $existingFolder = Get-RoyalObject -Folder $currentFolder -Name $folder -Type RoyalFolder
    if($existingFolder)
    {
      Write-Verbose "Folder $folder already exists - using it"
      $currentFolder = $existingFolder
    } else {
      Write-Verbose "Folder $folder does not exist - creating it"
      $newFolder= New-RoyalObject -Folder $currentFolder -Name $folder -Type RoyalFolder
      $currentFolder  = $newFolder
    }
  }
return $currentFolder
}

#Function to create a object, currently only for SSH, RDP and HTTPS JCL access
function royal_object() {
  param($Type,$Name,$Folder,$URI,$Port,$Username,$Password)

  switch ($Type) {
    "SSH" {
      $ObjectType = "RoyalSSHConnection"
    }
    "RDP" {
      $ObjectType = "RoyalRDSConnection"
    }
    "HTTPS" {
      $ObjectType = "RoyalWebConnection"
    }
  }

  $lastFolder = CreateRoyalFolderHierarchy -folderStructure $Folder -Splitter  "\/" -Folder $doc
  $newConnection = New-RoyalObject -Folder $lastFolder -Type $ObjectType -Name $Name
  $newConnection.CredentialUsername = $server.Username
  $newConnection.CredentialPassword = $server.Password
  $newConnection.CredentialMode = "2"
  switch ($Type) {
    "SSH" {
      $newConnection.URI = $URI
      $newConnection.Port = $Port
      $newConnection.WarnFingerprintMismatch = [bool]0
    }
    "RDP" {
      $newConnection.URI = $URI
      $newConnection.RDPPort = $Port
    }
    "HTTPS" {
      $newConnection.URI = -join("https://",$URI,":",$Port)
      $newConnection.IgnoreCertificateErrors = [bool]1
    }
  }

}

$fileName = $outputfile #relative to the current file-system directory
if(Test-Path $fileName) {Remove-Item $fileName}


$store = New-RoyalStore -UserName "JCL"
$doc = New-RoyalDocument -Store $store -Name "JCL Connections" -FileName $fileName
Import-CSV -Path $inputfile | %{

$server = $_

switch ($server.Service) {
  "SSH" {
    royal_object -Type $server.Service -Name $Server.Name -Folder "Private" -URI $server.PrivAddr -Port $server.PrivPort -Username $server.Username -Password $server.Password
    royal_object -Type $server.Service -Name $Server.Name -Folder "Public" -URI $server.PubAddr -Port $server.PubPort -Username $server.Username -Password $server.Password
  }
  "RDP" {
    royal_object -Type $server.Service -Name $Server.Name -Folder "Private" -URI $server.PrivAddr -Port $server.PrivPort -Username $server.Username -Password $server.Password
    royal_object -Type $server.Service -Name $Server.Name -Folder "Public" -URI $server.PubAddr -Port $server.PubPort -Username $server.Username -Password $server.Password
  }
  "HTTPS" {
    royal_object -Type $server.Service -Name $Server.Name -Folder "Private" -URI $server.PrivAddr -Port $server.PrivPort -Username $server.Username -Password $server.Password
    royal_object -Type $server.Service -Name $Server.Name -Folder "Public" -URI $server.PubAddr -Port $server.PubPort -Username $server.Username -Password $server.Password
  }
}


}
Out-RoyalDocument -Document $doc -FileName $fileName
