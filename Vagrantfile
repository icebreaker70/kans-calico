# Base Image : https://portal.cloud.hashicorp.com/vagrant/discover?query=ubuntu%2Fjammy64
#BOX_IMAGE = "ubuntu/jammy64"
#BOX_VERSION = "20240823.0.1"

# for MacBook Air - M1 with vmware-fusion
BOX_IMAGE = "bento/ubuntu-22.04-arm64"
BOX_VERSION = "202401.31.0"

# max number of worker nodes : Ex) N = 3
N = 2

# Version : Ex) k8s_V = '1.31'
k8s_V = '1.30'
cni_N = 'Calico'

Vagrant.configure("2") do |config|
#-----Manager Node
    config.vm.define "k8s-m" do |subconfig|
      subconfig.vm.box = BOX_IMAGE
      subconfig.vm.box_version = BOX_VERSION
      subconfig.vm.provider "vmare_desktop" do |v|
        v.customize ["modifyvm", :id, "--groups", "/#{cni_N}-Lab"]
        v.customize ["modifyvm", :id, "--nicpromisc2", "allow-vms"]
        v.name = "#{cni_N}-k8s-m"
        v.memory = 2048
        v.cpus = 2
        v.linked_clone = true
      end
      subconfig.vm.hostname = "k8s-m"
      subconfig.vm.synced_folder "./", "/vagrant", disabled: true
      subconfig.vm.network "private_network", ip: "192.168.10.10"
      subconfig.vm.network "forwarded_port", guest: 22, host: 50010, auto_correct: true, id: "ssh"
      subconfig.vm.provision "shell", path: "scripts/init_cfg.sh", args: [ N, k8s_V ]
      subconfig.vm.provision "shell", path: "scripts/route1.sh"
      subconfig.vm.provision "shell", path: "scripts/control.sh", args: [ cni_N ]
    end

#-----Router Node
    config.vm.define "router" do |subconfig|
      subconfig.vm.box = BOX_IMAGE
      subconfig.vm.box_version = BOX_VERSION
      subconfig.vm.provider "vmare_desktop" do |v|
        v.customize ["modifyvm", :id, "--groups", "/#{cni_N}-Lab"]
        v.name = "#{cni_N}-router"
        v.memory = 512
        v.cpus = 1
        v.linked_clone = true
      end
      subconfig.vm.hostname = "router"
      subconfig.vm.synced_folder "./", "/vagrant", disabled: true
      subconfig.vm.network "private_network", ip: "192.168.10.254"
      subconfig.vm.network "private_network", ip: "192.168.20.254"
      subconfig.vm.network "forwarded_port", guest: 22, host: 50000, auto_correct: true, id: "ssh"
      subconfig.vm.provision "shell", path: "scripts/linux_router.sh", args: [ N ]
    end

#-----Worker Node Subnet2
    config.vm.define "k8s-w0" do |subconfig|
      subconfig.vm.box = BOX_IMAGE
      subconfig.vm.box_version = BOX_VERSION
      subconfig.vm.provider "vmare_desktop" do |v|
        v.customize ["modifyvm", :id, "--groups", "/#{cni_N}-Lab"]
        v.name = "#{cni_N}-k8s-w0"
        v.memory = 2048
        v.cpus = 2
        v.linked_clone = true
      end
      subconfig.vm.hostname = "k8s-w0"
      subconfig.vm.synced_folder "./", "/vagrant", disabled: true
      subconfig.vm.network "private_network", ip: "192.168.20.100"
      subconfig.vm.network "forwarded_port", guest: 22, host: 50020, auto_correct: true, id: "ssh"
      subconfig.vm.provision "shell", path: "scripts/init_cfg.sh", args: [ N, k8s_V ]
      subconfig.vm.provision "shell", path: "scripts/route2.sh"
      subconfig.vm.provision "shell", path: "scripts/worker.sh"
    end

#-----Worker Node Subnet1
  (1..N).each do |i|
    config.vm.define "k8s-w#{i}" do |subconfig|
      subconfig.vm.box = BOX_IMAGE
      subconfig.vm.box_version = BOX_VERSION
      subconfig.vm.provider "vmare_desktop" do |v|
        v.customize ["modifyvm", :id, "--groups", "/#{cni_N}-Lab"]
        v.customize ["modifyvm", :id, "--nicpromisc2", "allow-vms"]
        v.name = "#{cni_N}-k8s-w#{i}"
        v.memory = 2048
        v.cpus = 2
        v.linked_clone = true
      end
      subconfig.vm.hostname = "k8s-w#{i}"
      subconfig.vm.synced_folder "./", "/vagrant", disabled: true
      subconfig.vm.network "private_network", ip: "192.168.10.10#{i}"
      subconfig.vm.network "forwarded_port", guest: 22, host: "5001#{i}", auto_correct: true, id: "ssh"
      subconfig.vm.provision "shell", path: "scripts/init_cfg.sh", args: [ N, k8s_V ]
      subconfig.vm.provision "shell", path: "scripts/route1.sh"
      subconfig.vm.provision "shell", path: "scripts/worker.sh"
    end
  end

end
