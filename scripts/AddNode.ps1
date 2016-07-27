param (
    [Parameter(Mandatory=$true)]
    [string] $NodeName,

    [Parameter(Mandatory=$true)]
    [string] $NodeType,

    [Parameter(Mandatory=$true)]
    [string] $NodeIpAddressOrFQDN,

    [Parameter(Mandatory=$true)]
    [string] $ExistingClusterConnectionEndpoint,
    
    [Parameter(Mandatory=$true)]
    [string] $UpgradeDomain,

    [Parameter(Mandatory=$true)]
    [string] $FaultDomain
)

$MicrosoftServiceFabricCabFilePath = Resolve-Path .\Microsoft.Azure.ServiceFabric.WindowsServer\MicrosoftAzureServiceFabric.cab

./Microsoft.Azure.ServiceFabric.WindowsServer/AddNode.ps1 -MicrosoftServiceFabricCabFilePath $MicrosoftServiceFabricCabFilePath -ExistingClusterConnectionEndpoint $ExistingClusterConnectionEndpoint -NodeName $NodeName -NodeType $NodeType -NodeIpAddressOrFQDN $NodeIpAddressOrFQDN -UpgradeDomain $UpgradeDomain -FaultDomain $FaultDomain -AcceptEULA