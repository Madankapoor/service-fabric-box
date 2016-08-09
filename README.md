# Service Fabric Box
This is a local setup using Vagrant for running an [Azure Service Fabric](https://azure.microsoft.com/en-us/services/service-fabric/) cluster with an insecure private network on a set of computers running Windows Server. The configuration follows the [instructions](https://azure.microsoft.com/en-us/documentation/articles/service-fabric-cluster-creation-for-windows-server/) for setting up an on-premise cluster. The setup is tested with boxes running Windows Server 2016 TP5 and Windows Server 2012 R2.

For this example you will need to Windows Server key (register for an evaluation copy [here](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-technical-preview)), [Vagrant](https://www.vagrantup.com/), [Packer](https://www.packer.io/) and [VirtualBox](https://www.virtualbox.org/). Optionally you need to prepare your local [development environment for Service Fabric](https://azure.microsoft.com/en-us/documentation/articles/service-fabric-get-started/) if you wish to run Powershell commands against the cluster or deploy apps.

## The cluster config
The cluster configuration is based on the file ClusterConfig.Unsecure.MultiMachine.json from the [Windows Server package](http://go.microsoft.com/fwlink/?LinkID=733084) with IP addresses added for the initial nodes. 

## The Vagrant boxes
The cluster consists of three VM's and a fourth VM set up for joining the running cluster.

| VM  | IP address     | Roles           |
|-----|----------------|-----------------| 
| vm0 | 192.168.38.100 | Creates cluster |
| vm1 | 192.168.38.101 | Initial node 1  |
| vm2 | 192.168.38.102 | Initial node 2  |
| vm3 | 192.168.38.103 | Ready to join   |
## Get the base box
Follow the instructions at [StefanScherer/docker-windows-box](https://github.com/StefanScherer/docker-windows-box) to create the base box for either Windows Server 2016 TP5 or Windows Server 2012 R2 or both.
To build the base box for Windows Server 2016 TP5 you have to run these commands on your host machine:
```
git clone https://github.com/StefanScherer/packer-windows
cd packer-windows
packer build --only=virtualbox windows_2016.json
vagrant box add windows_2016 windows_2016_virtualbox.box
```
or alternatively for Windows Server 2012 R2, run
```
packer build --only=virtualbox windows_2012_r2.json
vagrant box add windows_2012_r2 windows_2012_r2_virtualbox.box
```
## Initialize the cluster
Start up the cluster with the three initial nodes
```
vagrant up --provider virtualbox
```
### Check the cluster nodes
Go to the Service Fabric Explorer at the cluster http gateway endpoint [192.168.38.100:19080](http://192.168.38.100:19080) to verify that the cluster is running. The "Nodes" section will look like this:

![](https://raw.githubusercontent.com/spoorendonk/service-fabric-box/master/images/added-node-explorer.png)

This can also be checked with Powershell
```
PS C:\> Connect-ServiceFabricCluster -ConnectionEndpoint 192.168.38.100:19000
PS C:\> Get-ServiceFabricNode


NodeName        : vm2
NodeId          : 5101db1125ead8d47d6f93321d3eb754
NodeInstanceId  : 131141069773830889
NodeType        : NodeType0
NodeStatus      : Up
NodeUpTime      : 00:13:05
HealthState     : Ok
CodeVersion     : 5.1.156.9590
ConfigVersion   : 1.0.0
IsSeedNode      : True
IpAddressOrFQDN : 192.168.38.102
FaultDomain     : fd:/dc3/r0
UpgradeDomain   : UD2

NodeName        : vm1
NodeId          : 80b671e9b3c9184bbd86d2f150c58135
NodeInstanceId  : 131141069776099587
NodeType        : NodeType0
NodeStatus      : Up
NodeUpTime      : 00:13:05
HealthState     : Ok
CodeVersion     : 5.1.156.9590
ConfigVersion   : 1.0.0
IsSeedNode      : True
IpAddressOrFQDN : 192.168.38.101
FaultDomain     : fd:/dc2/r0
UpgradeDomain   : UD1

NodeName        : vm0
NodeId          : 85772935593a0315f92e3293832c5fe9
NodeInstanceId  : 131141069844065839
NodeType        : NodeType0
NodeStatus      : Up
NodeUpTime      : 00:13:05
HealthState     : Ok
CodeVersion     : 5.1.156.9590
ConfigVersion   : 1.0.0
IsSeedNode      : True
IpAddressOrFQDN : 192.168.38.100
FaultDomain     : fd:/dc1/r0
UpgradeDomain   : UD0
```
## Add a node to the cluster

Join the fourth VM to the cluster by running
```
vagrant up vm3 --provider virtualbox
```
Checking the "Nodes" section in the Service Fabric Explorer will show that the fourth node has joined the cluster.

![](https://raw.githubusercontent.com/spoorendonk/service-fabric-box/master/images/added-node-explorer.png)

or with Powershell
```
PS C:\> Get-ServiceFabricNode


NodeName        : vm3
NodeId          : 308edf54e3edba6c1063f1d2334fe211
NodeInstanceId  : 131141081479230670
NodeType        : NodeType0
NodeStatus      : Up
NodeUpTime      : 00:04:40
HealthState     : Ok
CodeVersion     : 5.1.156.9590
ConfigVersion   : 1.0.0
IsSeedNode      : False
IpAddressOrFQDN : 192.168.38.103
FaultDomain     : fd:/dc2/r0
UpgradeDomain   : UD1

NodeName        : vm2
NodeId          : 5101db1125ead8d47d6f93321d3eb754
NodeInstanceId  : 131141069773830889
NodeType        : NodeType0
NodeStatus      : Up
NodeUpTime      : 00:23:32
HealthState     : Ok
CodeVersion     : 5.1.156.9590
ConfigVersion   : 1.0.0
IsSeedNode      : True
IpAddressOrFQDN : 192.168.38.102
FaultDomain     : fd:/dc3/r0
UpgradeDomain   : UD2

NodeName        : vm1
NodeId          : 80b671e9b3c9184bbd86d2f150c58135
NodeInstanceId  : 131141069776099587
NodeType        : NodeType0
NodeStatus      : Up
NodeUpTime      : 00:23:32
HealthState     : Ok
CodeVersion     : 5.1.156.9590
ConfigVersion   : 1.0.0
IsSeedNode      : True
IpAddressOrFQDN : 192.168.38.101
FaultDomain     : fd:/dc2/r0
UpgradeDomain   : UD1

NodeName        : vm0
NodeId          : 85772935593a0315f92e3293832c5fe9
NodeInstanceId  : 131141069844065839
NodeType        : NodeType0
NodeStatus      : Up
NodeUpTime      : 00:23:32
HealthState     : Ok
CodeVersion     : 5.1.156.9590
ConfigVersion   : 1.0.0
IsSeedNode      : True
IpAddressOrFQDN : 192.168.38.100
FaultDomain     : fd:/dc1/r0
UpgradeDomain   : UD0
```

## Deploy an app
Now that the cluster is up an running we will deploy an app to it. We will deploy the [getting starting samples](https://azure.microsoft.com/en-us/documentation/samples/service-fabric-dotnet-getting-started/) WordCount app and for simplicity we will deploy it directly from Visual Studio 2015. For more advanced use cases the Service Fabric docummentation describes how to [package](https://azure.microsoft.com/en-us/documentation/articles/service-fabric-application-model/#package-an-application) and [deploy](https://azure.microsoft.com/en-us/documentation/articles/service-fabric-deploy-remove-applications) an app using Powershell.

1. Get the code following this [link](https://azure.microsoft.com/en-us/documentation/samples/service-fabric-dotnet-getting-started/) and open the WordCount solution located in the `Services\WordCount` folder.

2. In the `WordCount` project insert the cluster endpoint into the `PublishProfiles\Cloud.xml` file such that the file looks like this
   
   ```
   <?xml version="1.0" encoding="utf-8"?>
   <PublishProfile xmlns="http://schemas.microsoft.com/2015/05/fabrictools">
     <ClusterConnectionParameters ConnectionEndpoint="192.168.38.100:19000" />
     <ApplicationParameterFile Path="..\ApplicationParameters\Cloud.xml" />
   </PublishProfile>
   ```

3. Right click on the `WordCount` project and select "Publish..." and the following box appears:

   ![](https://raw.githubusercontent.com/spoorendonk/service-fabric-box/master/images/publish-vs2015.png)

4. Press the "Publish" button and wait for the app to be deployed to the cluster.

5. Verify that the app is running

   ```
   PS C:\> Get-ServiceFabricApplication
   ApplicationName        : fabric:/WordCount
   ApplicationTypeName    : WordCount
   ApplicationTypeVersion : 1.0.0
   ApplicationStatus      : Ready
   HealthState            : Ok
   ApplicationParameters  : {}
   ```
   or access the Service Fabric Explorer and look in the "Applications" section

   ![](https://raw.githubusercontent.com/spoorendonk/service-fabric-box/master/images/wordcount-explorer.png)

8. To see the WordCount app in action we need to open the firewall for the app endpoint. Log into one of the VMs in the cluster, e.g., 192.168.38.100, and run

   ```
   PS C:\> New-NetFirewallRule -DisplayName "WordCount" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 8081
   ``` 
   Go to [http://192.168.38.100:8081/WordCount](http://192.168.38.100:8081/WordCount) to see the action.

   ![](https://raw.githubusercontent.com/spoorendonk/service-fabric-box/master/images/wordcount-browser.png)
