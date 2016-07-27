# disable firewall for private network

param (
    [Parameter(Mandatory=$true)]
    [string] $NetworkName
)

Import-Module NetSecurity

Set-NetConnectionProfile -InterfaceAlias $NetworkName -NetworkCategory Private
Set-NetFirewallProfile -Name Private -DisabledInterfaceAliases $NetworkName