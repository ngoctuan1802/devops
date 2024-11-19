Vagrant.configure("2") do |config|
  # Define VM configurations in a loop
  (1..3).each do |i|
    config.vm.define "k8s-master-#{i}" do |node|
      node.vm.box = "ubuntu/focal64"
      node.vm.hostname = "k8s-master-#{i}"

      # Assign a static IP
      node.vm.network "public_network", ip: "192.168.1.11#{i}"

      # Provider-specific configuration (VMware Workstation)
      node.vm.provider :vmware_workstation do |v|
        v.gui = false
        v.vmx["numvcpus"] = "2"
        v.vmx["cpuid.coresPerSocket"] = "2"
        v.vmx["vhv.enable"] = "TRUE"
        v.vmx["memsize"] = "4096"
        v.vmx["displayname"] = "k8s-master-#{i}"
        v.vmx["guestOS"] = "ubuntu-64"
      end

      # Provision to set up /etc/hosts
      node.vm.provision "shell", inline: <<-SHELL
        # Define hosts entries for the Kubernetes cluster
        HOSTS=(
          "192.168.1.111 k8s-master-1"
          "192.168.1.112 k8s-master-2"
          "192.168.1.113 k8s-master-3"
        )

        for HOST in "${HOSTS[@]}"; do
          if ! grep -q "$HOST" /etc/hosts; then
            echo "$HOST" | sudo tee -a /etc/hosts > /dev/null
          fi
        done
      SHELL
    end
  end
end
