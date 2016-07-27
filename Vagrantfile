# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.require_version ">= 1.7.4"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box          = "windows_2016"
  config.vm.communicator = "winrm"

  config.vm.provider "virtualbox" do |v|
    v.gui = true
    v.customize ["modifyvm", :id, "--memory", 2048]
    v.customize ["modifyvm", :id, "--cpus", 2]
    v.customize ["modifyvm", :id, "--vram", 64]
    v.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
    v.customize ["modifyvm", :id, "--accelerate3d", "on"]
    v.customize ["modifyvm", :id, "--accelerate2dvideo", "on"]
    v.linked_clone = true if Vagrant::VERSION =~ /^1.8/
  end

  ["vmware_fusion", "vmware_workstation"].each do |provider|
    config.vm.provider provider do |v, override|
      v.gui = true
      v.vmx["memsize"] = "2048"
      v.vmx["numvcpus"] = "2"
      v.vmx["vhv.enable"] = "TRUE"
      v.enable_vmrun_ip_lookup = false
    end
  end

  config.vm.define "wm1" do |config|
    config.vm.hostname = "wm1"
    config.vm.network "private_network", ip: "192.168.38.101", gateway: "192.168.38.1"
	  config.vm.provision "shell", path: "scripts/SetupNetwork.ps1", :args => "-NetworkName 'Ethernet 2'", privileged: true
  end

  config.vm.define "vm2" do |config|
    config.vm.hostname = "wm2"
    config.vm.network :private_network, ip: "192.168.38.102", gateway: "192.168.38.1"
	  config.vm.provision "shell", path: "scripts/SetupNetwork.ps1", :args => "-NetworkName 'Ethernet 2'", privileged: true
  end
  
  config.vm.define "vm0" do |config|
    config.vm.hostname = "wm0"
    config.vm.network :private_network, ip: "192.168.38.100", gateway: "192.168.38.1"
	  config.vm.provision "shell", path: "scripts/SetupNetwork.ps1", :args => "-NetworkName 'Ethernet 2'", privileged: true
	  config.vm.provision "shell", path: "scripts/ServiceFabric.ps1", privileged: true
	  config.vm.provision "file", source: "ClusterConfig.Unsecure.MultiMachine.json", destination: "c:/tmp/ClusterConfig.json"
	  config.vm.provision "shell", path: "scripts/CreateServiceFabricCluster.ps1", :args => "-ClusterConfigFilePath c:/tmp/ClusterConfig.json", privileged: true
  end
  
  config.vm.define "vm3", autostart: false do |config|
    config.vm.hostname = "wm3"
    config.vm.network :private_network, ip: "192.168.38.103", gateway: "192.168.38.1"
	  config.vm.provision "shell", path: "scripts/SetupNetwork.ps1", :args => "-NetworkName 'Ethernet 2'", privileged: true	
	  config.vm.provision "shell", path: "scripts/ServiceFabric.ps1", privileged: true
	  config.vm.provision "shell", path: "scripts/vcredistInstall.bat", privileged: true
	  config.vm.provision "shell", path: "scripts/ModifyAddNodeScript.ps1", privileged: true
	  config.vm.provision "shell", path: "scripts/AddNode.ps1", :args => "-NodeName vm3 -NodeType NodeType0 -NodeIPAddressorFQDN 192.168.38.103 -ExistingClusterConnectionEndPoint 192.168.38.100:19000 -UpgradeDomain UD1 -FaultDomain fd:/dc2/r0", privileged: true	
  end
end
