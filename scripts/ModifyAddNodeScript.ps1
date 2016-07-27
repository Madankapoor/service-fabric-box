# Workaround for version Microsoft.Azure.ServiceFabric.WindowsServer.5.1.156.9590
# Modify AddNode.ps1 script to accept EULA as a parameter 

$fileName = Resolve-Path ./Microsoft.Azure.ServiceFabric.WindowsServer/AddNode.ps1

$lineNumber = 1
$fileContent = Get-Content $fileName

$fileContent[$lineNumber-1] += 
"
[Parameter(Mandatory=`$false)]
[switch] `$AcceptEULA,
"

$fileContent | Set-Content $fileName