param (
    [Parameter(Mandatory=$true)]
    [string] $ClusterConfigFilePath
)

$MicrosoftServiceFabricCabFilePath = Resolve-Path .\Microsoft.Azure.ServiceFabric.WindowsServer\MicrosoftAzureServiceFabric.cab

.\Microsoft.Azure.ServiceFabric.WindowsServer\CreateServiceFabricCluster.ps1 -ClusterConfigFilePath $ClusterConfigFilePath -MicrosoftServiceFabricCabFilePath $MicrosoftServiceFabricCabFilePath -AcceptEULA $true -Verbose