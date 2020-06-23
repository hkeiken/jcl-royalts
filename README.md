**jcl-royalts-import**

Small Powershell script using RoyalDocument.PowerShell module to create a RoyalTS / RoyalTSX document from a JCS CSV file with credentials. Two folders, Private and Public is created to store objects for both internal and external destination addresses.


usage: jcl-royalts-import -inputfile input.csv -outputfile output.rtsz

Tested on OSX and Linux using version 5.2.60224 of the RoyalDocument.PowerShell module. In this version an error message seen below is observed, but this has no impact on the function:

```PS /root> ./jcl-royalts-import.ps1
New-RoyalStore: /root/jcl-royalts-import.ps1:105
Line |
105 |  $store = New-RoyalStore -UserName "JCL"
     |           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     | The method or operation is not implemented.
```
